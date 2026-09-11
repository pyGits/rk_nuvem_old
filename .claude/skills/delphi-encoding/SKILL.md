---
name: delphi-encoding
description: Ler, editar e gravar fontes Delphi (.pas .dfm .dpr .inc) deste repositório sem destruir os acentos. Use SEMPRE antes de qualquer edição em arquivo Delphi — inclusive quando parecer uma troca trivial de uma linha, e mesmo que a edição não toque em texto acentuado. Também cobre o conserto de arquivo que já saiu com "?" ou "�" no lugar do acento.
---

# Encoding dos fontes Delphi

Os fontes deste repositório **não são UTF-8**. O legado (`RK_Pdv_Claude`, `Sync_NUVEM`,
`RK_Retaguarda_novo_Claude`) é **CP1252 sem BOM**; só `Infra2/` é UTF-8, às vezes com BOM. O
encoding é **por arquivo** — nunca assuma pelo diretório.

Ler um arquivo CP1252 como UTF-8 com `errors='replace'` troca cada byte acentuado por `U+FFFD`. Se o
arquivo for regravado assim, o acento **morre**: `necessário` vira `necess?rio` na tela do PDV, e não
há como recuperar do próprio arquivo. Foi exatamente o que aconteceu com `venda.pas` — 45 acentos
perdidos de uma vez, descobertos só quando o caixa viu o "?" na mensagem de virada de movimento.

## Regras

1. **Detecte antes de abrir para escrita.** Nunca escreva num `.pas` sem saber o encoding dele.
2. **Grave no mesmo encoding que leu**, com `newline=''` para preservar o CRLF.
3. **Nunca use `errors='replace'` ou `errors='ignore'`** ao ler fonte que você vai regravar. Se a
   leitura falhar, o encoding está errado — descubra o certo, não force a leitura.
4. **Confira por codepoint depois de gravar.** O terminal do Git Bash mostra byte CP1252 como `�`
   mesmo quando o arquivo está correto: olhar a saída de `cat`/`grep` **não prova nada**. A
   verificação válida é `hex(ord(c))`, ou a contagem de `U+FFFD`.
5. **Evite `sed -i`, `>` e `Set-Content`** em fonte Delphi: reescrevem o arquivo no encoding do
   shell. Use o utilitário abaixo.

## Como fazer

O utilitário `scripts/pasedit.py` cobre os três passos:

```bash
S=".claude/skills/delphi-encoding/scripts/pasedit.py"

# 1) detectar (faça isso ANTES de editar)
python "$S" detect RK_Pdv_Claude/venda.pas

# 2) editar - troca literal, exige match unico, preserva encoding e CRLF
python "$S" replace RK_Pdv_Claude/venda.pas /tmp/de.txt /tmp/para.txt

# 3) conferir - lista os codepoints acentuados e acusa qualquer U+FFFD
python "$S" check RK_Pdv_Claude/venda.pas
```

Para edições feitas na mão em Python, o padrão é:

```python
import io
p, enc = 'RK_Pdv_Claude/venda.pas', 'cp1252'   # enc vem do 'detect'
d = io.open(p, encoding=enc, newline='').read()  # sem errors=
assert d.count(velho) == 1
io.open(p, 'w', encoding=enc, newline='').write(d.replace(velho, novo))
```

Ao escrever texto novo que vai para a tela do operador, use os acentos corretos (`máximo`, `não`,
`código`) — CP1252 os representa sem problema. Comentários de código neste repositório costumam ser
escritos sem acento; siga o arquivo.

## Se um arquivo já saiu corrompido

Sintoma: `?` ou `�` na tela do PDV. Confirme contando `U+FFFD` (`check` acusa).

Os acentos perdidos não estão mais no arquivo — têm que vir de outra cópia:

1. `Desktop/Projetos/backup/RK_Pdv_Claude/` — cópia de junho/2026, ainda em CP1252.
2. `__history/<arquivo>.~N~` do Delphi (só registra salvamento feito pelo IDE, costuma estar atrasado).
3. Transcripts em `~/.claude/projects/.../*.jsonl`, que guardam os scripts de edição literais.

Com uma cópia boa em mãos, `python "$S" fix <arquivo> <copia_boa>` devolve cada acento casando o
contexto ao redor do `U+FFFD`. Linhas escritas depois da cópia não têm de onde tirar o acento: o
comando lista essas pendências para você corrigir explicitamente, e não grava nada enquanto sobrar
alguma.

Ver também a memória `delphi-arquivos-ansi-1252` e, para o histórico de recuperação neste repo,
`rk-pdv-claude-repo-git-separado`.
