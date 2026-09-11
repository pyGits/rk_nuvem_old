# -*- coding: utf-8 -*-
"""Le, edita e confere fontes Delphi preservando o encoding do arquivo.

    python pasedit.py detect  <arquivo>
    python pasedit.py check   <arquivo>
    python pasedit.py replace <arquivo> <arq_de> <arq_para>
    python pasedit.py fix     <arquivo> <copia_boa> [--force]

'replace' troca texto literal (conteudo dos arquivos de/para), exige match unico
e regrava no mesmo encoding e com as mesmas quebras de linha.

'fix' devolve os acentos de um arquivo que foi lido como UTF-8 e regravado, o que
troca cada byte acentuado por U+FFFD. Casa o contexto ao redor de cada U+FFFD com
a copia boa; nao grava nada enquanto sobrar pendencia.
"""
import io
import os
import re
import sys

FFFD = '�'


def detectar(path):
    """Retorna (encoding, tem_bom, crlf). Nao adivinha: testa na ordem em que os
    fontes deste repo aparecem e devolve a primeira que decodifica inteira."""
    d = open(path, 'rb').read()
    crlf = d.count(b'\r\n') > 0
    if d[:3] == b'\xef\xbb\xbf':
        return 'utf-8-sig', True, crlf
    try:
        d.decode('utf-8')
        # ASCII puro decodifica como utf-8 e como cp1252; assume o do legado
        if all(b < 128 for b in d):
            return 'cp1252', False, crlf
        return 'utf-8', False, crlf
    except UnicodeDecodeError:
        pass
    d.decode('cp1252')  # estoura se nem isso servir, e ai e bom saber
    return 'cp1252', False, crlf


def ler(path):
    enc, _, _ = detectar(path)
    return io.open(path, encoding=enc, newline='').read(), enc


def cmd_detect(path):
    enc, bom, crlf = detectar(path)
    d = open(path, 'rb').read()
    print('arquivo   :', path)
    print('encoding  :', enc, '(com BOM)' if bom else '(sem BOM)')
    print('quebras   :', 'CRLF' if crlf else 'LF')
    print('bytes     :', len(d))
    print('nao-ascii :', sum(1 for b in d if b > 127))
    print('U+FFFD    :', d.count(b'\xef\xbf\xbd'), '<-- ACENTOS PERDIDOS' if d.count(b'\xef\xbf\xbd') else '')


def cmd_check(path):
    t, enc = ler(path)
    ruins = t.count(FFFD)
    print('encoding:', enc, '| nao-ascii:', sum(1 for c in t if ord(c) > 127),
          '| U+FFFD:', ruins)
    palavras = []
    for m in re.finditer(r'\w*[^\x00-\x7f]\w*', t):
        if m.group(0) not in palavras:
            palavras.append(m.group(0))
    for w in palavras:
        marca = '  <-- CORROMPIDA' if FFFD in w else ''
        cps = ' '.join(hex(ord(c)) for c in w if ord(c) > 127)
        print('   %-24s %s%s' % (w, cps, marca))
    return 1 if ruins else 0


def cmd_replace(path, arq_de, arq_para):
    t, enc = ler(path)
    de = io.open(arq_de, encoding='utf-8', newline='').read()
    para = io.open(arq_para, encoding='utf-8', newline='').read()
    # casa as quebras de linha do alvo
    if '\r\n' in t:
        de = de.replace('\r\n', '\n').replace('\n', '\r\n')
        para = para.replace('\r\n', '\n').replace('\n', '\r\n')
    n = t.count(de)
    if n != 1:
        print('ERRO: o texto de origem aparece %d vezes (esperado 1). Nada gravado.' % n)
        return 1
    io.open(path, 'w', encoding=enc, newline='').write(t.replace(de, para))
    print('ok, gravado em', enc)
    return cmd_check(path)


def cmd_fix(path, copia, force=False):
    atual, enc_atual = ler(path)
    boa, _ = ler(copia)
    total = atual.count(FFFD)
    print('U+FFFD a recuperar:', total)
    if not total:
        print('nada a fazer')
        return 0

    JAN = 18
    out, i, pend = [], 0, []
    while True:
        j = atual.find(FFFD, i)
        if j < 0:
            out.append(atual[i:])
            break
        out.append(atual[i:j])
        esq, dir_ = atual[max(0, j - JAN):j], atual[j + 1:j + 1 + JAN]
        pat = (re.escape(esq).replace(re.escape(FFFD), '.') + '(.)' +
               re.escape(dir_).replace(re.escape(FFFD), '.'))
        achados = set(m.group(1) for m in re.finditer(pat, boa))
        if len(achados) == 1:
            out.append(achados.pop())
        else:
            out.append(FFFD)
            pend.append((esq[-25:].replace('\n', ' '), dir_[:25].replace('\n', ' ')))
        i = j + 1

    novo = ''.join(out)
    print('recuperados:', total - len(pend), '| pendentes:', len(pend))
    for e, d_ in pend:
        print('   ...%s <?> %s...' % (e, d_))
    if pend and not force:
        print('\nNada gravado: corrija as pendencias no proprio arquivo e rode de novo.')
        return 1
    io.open(path, 'w', encoding=enc_atual if enc_atual != 'utf-8' else 'cp1252',
            newline='').write(novo)
    print('gravado')
    return cmd_check(path)


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        return 2
    cmd, path = sys.argv[1], sys.argv[2]
    if not os.path.exists(path):
        print('nao encontrado:', path)
        return 2
    if cmd == 'detect':
        return cmd_detect(path) or 0
    if cmd == 'check':
        return cmd_check(path)
    if cmd == 'replace':
        return cmd_replace(path, sys.argv[3], sys.argv[4])
    if cmd == 'fix':
        return cmd_fix(path, sys.argv[3], '--force' in sys.argv)
    print(__doc__)
    return 2


if __name__ == '__main__':
    sys.exit(main())
