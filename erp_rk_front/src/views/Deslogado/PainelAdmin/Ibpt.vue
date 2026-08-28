<template>
  <MenuAdmin>
    <v-card flat>
      <div class="d-flex align-center flex-wrap px-6 py-4 cabecalho">
        <v-icon large color="primary" class="mr-3">mdi-table-large</v-icon>
        <div class="mr-4">
          <h2 class="text-h5 font-weight-medium mb-0">Tabela IBPT</h2>
          <span class="text-caption grey--text text--darken-1"> Catálogo de NCM e alíquotas da Lei da Transparência, usado por todos os clientes </span>
        </div>
        <v-spacer></v-spacer>
        <v-btn color="primary" depressed @click="dialogUpload = true">
          <v-icon left>mdi-upload</v-icon>
          Enviar tabela
        </v-btn>
      </div>

      <v-card-text>
        <!-- Situação da carga -->
        <v-alert v-if="!carregando && !situacao?.carga" type="warning" text class="mb-4">
          Nenhuma tabela carregada ainda. Envie o arquivo <strong>.csv</strong> do IBPT para que os clientes consigam consultar NCM.
        </v-alert>

        <v-row v-else-if="situacao?.carga" dense class="mb-2">
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Versão</div>
              <div class="text-h6">{{ situacao.carga.versao || "-" }}</div>
            </v-sheet>
          </v-col>
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Vigência</div>
              <div class="text-h6">{{ formatarData(situacao.carga.vigenciaInicio) }} a {{ formatarData(situacao.carga.vigenciaFim) }}</div>
            </v-sheet>
          </v-col>
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">NCM na tabela</div>
              <div class="text-h6">{{ situacao.total }}</div>
            </v-sheet>
          </v-col>
          <v-col cols="12" sm="3">
            <v-sheet outlined rounded class="pa-3">
              <div class="text-caption grey--text">Carregada em</div>
              <div class="text-h6">{{ formatarDataHora(situacao.carga.carregadoEm) }}</div>
              <div class="text-caption grey--text text-truncate">{{ situacao.carga.arquivo }}</div>
            </v-sheet>
          </v-col>
        </v-row>

        <!-- Vigência vencida: a tabela do IBPT é trimestral. -->
        <v-alert v-if="vigenciaVencida" type="info" text dense class="mb-4"> A vigência desta tabela terminou em {{ formatarData(situacao.carga.vigenciaFim) }}. O IBPT publica uma versão nova a cada trimestre. </v-alert>

        <v-divider class="my-4"></v-divider>

        <!-- Correção do zero à esquerda: determinística, separada da sugestão -->
        <v-sheet outlined rounded class="pa-4 mb-4">
          <div class="d-flex align-center flex-wrap">
            <div>
              <h3 class="text-subtitle-1 font-weight-medium mb-0">NCM sem o zero à esquerda</h3>
              <span class="text-caption grey--text text--darken-1">
                O PDV guarda o NCM em campo numérico e o zero da frente se perde. "4039000" é o iogurte 04039000. Não é palpite: completa para 8 dígitos.
              </span>
            </div>
            <v-spacer></v-spacer>
            <span v-if="zeroTotal !== null" class="mr-4 text-body-2">
              <strong :class="zeroTotal ? 'primary--text' : 'grey--text'">{{ zeroTotal }}</strong> produto(s)
            </span>
            <v-btn outlined class="mr-2" :loading="contandoZero" @click="contarZero">
              <v-icon left>mdi-magnify</v-icon>
              Verificar
            </v-btn>
            <v-btn color="primary" depressed :disabled="!zeroTotal" :loading="corrigindoZero" @click="corrigirZero">
              <v-icon left>mdi-numeric-0-box</v-icon>
              Corrigir
            </v-btn>
          </div>
        </v-sheet>

        <!-- Mutirão da IA: roda no servidor, a tela pode ser fechada -->
        <v-sheet outlined rounded class="pa-4 mb-4">
          <div class="d-flex align-center flex-wrap">
            <div>
              <h3 class="text-subtitle-1 font-weight-medium mb-0">Mutirão de NCM por IA</h3>
              <span class="text-caption grey--text text--darken-1">
                Percorre os produtos de todos os inquilinos no servidor, repetindo sozinho quando a IA está sobrecarregada. Pode fechar esta tela.
              </span>
            </div>
            <v-spacer></v-spacer>
            <v-checkbox v-model="mutiraoReconsultar" label="Reconsultar os sem resposta" hide-details dense class="mr-4 mt-0" :disabled="mutirao.rodando"></v-checkbox>
            <v-btn v-if="!mutirao.rodando" color="purple" dark :loading="iniciandoMutirao" @click="iniciarMutirao">
              <v-icon left>mdi-robot-outline</v-icon>
              Iniciar
            </v-btn>
            <v-btn v-else color="error" outlined @click="pararMutirao">
              <v-icon left>mdi-stop</v-icon>
              Parar
            </v-btn>
          </div>

          <template v-if="mutirao.total">
            <v-progress-linear :value="progressoMutirao" height="22" rounded :color="mutirao.rodando ? 'purple' : 'grey'" class="mt-3">
              <span class="text-caption white--text">{{ mutirao.processados }} / {{ mutirao.total }}</span>
            </v-progress-linear>

            <div class="text-caption grey--text text--darken-1 mt-1">
              {{ mutirao.comSugestao }} com NCM ·
              <span v-if="mutirao.rodando">em andamento</span>
              <span v-else>parado</span>
              <span v-if="mutirao.tentativas"> · {{ mutirao.tentativas }} nova(s) tentativa(s)</span>
            </div>

            <v-alert v-if="mutirao.ultimoErro" :type="mutirao.cotaDiaria ? 'error' : 'warning'" text dense class="mt-2 mb-0">
              {{ mutirao.ultimoErro }}<span v-if="!mutirao.cotaDiaria"> — repetindo automaticamente.</span>
            </v-alert>
          </template>
        </v-sheet>

        <!-- Busca na SEFAZ pelo código de barras: consulta exata, não palpite -->
        <v-sheet outlined rounded class="pa-4 mb-4">
          <div class="d-flex align-center flex-wrap">
            <div>
              <h3 class="text-subtitle-1 font-weight-medium mb-0">Buscar NCM na SEFAZ (por código de barras)</h3>
              <span class="text-caption grey--text text--darken-1">
                Consulta o Cadastro Centralizado de GTIN com o certificado digital de uma loja cadastrada. Só atende GTIN da GS1 Brasil (789/790). Pode fechar esta tela.
              </span>
            </div>
            <v-spacer></v-spacer>
            <v-btn v-if="!sefaz.rodando" color="teal" dark :loading="iniciandoSefaz" :disabled="!certificado.emUso" @click="iniciarSefaz">
              <v-icon left>mdi-barcode-scan</v-icon>
              Buscar pela SEFAZ
            </v-btn>
            <v-btn v-else color="error" outlined @click="pararSefaz">
              <v-icon left>mdi-stop</v-icon>
              Parar
            </v-btn>
          </div>

          <template v-if="sefaz.total">
            <v-progress-linear :value="progressoSefaz" height="22" rounded :color="sefaz.rodando ? 'teal' : 'grey'" class="mt-3">
              <span class="text-caption white--text">{{ sefaz.processados }} / {{ sefaz.total }}</span>
            </v-progress-linear>

            <div class="text-caption grey--text text--darken-1 mt-1">
              {{ sefaz.comNcm }} com NCM ·
              <span v-if="sefaz.rodando">em andamento</span>
              <span v-else>parado</span>
            </div>

            <v-alert v-if="sefaz.ultimoErro" :type="sefaz.bloqueado ? 'error' : 'warning'" text dense class="mt-2 mb-0">
              {{ sefaz.ultimoErro }}
            </v-alert>
          </template>

          <v-divider class="my-4"></v-divider>

          <!-- Certificado digital que assina as consultas -->
          <div class="d-flex align-center flex-wrap mb-2">
            <v-icon small class="mr-2" :color="certificado.emUso ? 'teal' : 'grey'">mdi-certificate-outline</v-icon>
            <span class="text-subtitle-2 font-weight-medium">Certificado digital</span>
            <v-spacer></v-spacer>
            <v-btn v-if="certificado.temProprio" small text color="error" :disabled="sefaz.rodando" @click="removerCertificado">
              <v-icon left small>mdi-delete-outline</v-icon>
              Remover
            </v-btn>
          </div>

          <v-alert v-if="certificado.temProprio" :type="certificado.vencido ? 'error' : 'success'" text dense class="mb-3">
            <div class="font-weight-medium">{{ certificado.titular }}</div>
            <div class="text-caption">
              {{ certificado.documento }} · válido até {{ formatarDataHora(certificado.validade) }}
              <span v-if="certificado.vencido"> — VENCIDO</span>
            </div>
          </v-alert>

          <!-- Sem certificado proprio o sistema cai no de um cliente, e isso
               precisa estar visivel: o bloqueio da SEFAZ recai sobre o CNPJ de
               quem assina. -->
          <v-alert v-else-if="certificado.emUso" type="warning" text dense class="mb-3">
            Sem certificado próprio. As consultas sairiam assinadas por
            <strong>{{ certificado.emUso.titular || certificado.emUso.documento }}</strong>, de uma loja cliente —
            e um bloqueio da SEFAZ por excesso de consultas recairia sobre esse CNPJ.
          </v-alert>
          <v-alert v-else type="error" text dense class="mb-3">
            Nenhum certificado digital disponível. Envie um certificado A1 para consultar a SEFAZ.
          </v-alert>

          <v-row dense align="center">
            <v-col cols="12" sm="5">
              <v-file-input
                v-model="certificadoArquivo"
                accept=".pfx,.p12"
                label="Certificado A1 (.pfx)"
                prepend-icon="mdi-certificate-outline"
                outlined
                dense
                hide-details
                show-size
                :disabled="enviandoCertificado"
              ></v-file-input>
            </v-col>
            <v-col cols="12" sm="4">
              <v-text-field
                v-model="certificadoSenha"
                label="Senha do certificado"
                type="password"
                outlined
                dense
                hide-details
                autocomplete="new-password"
                :disabled="enviandoCertificado"
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="3">
              <v-btn block color="teal" dark :loading="enviandoCertificado" @click="enviarCertificado">
                <v-icon left>mdi-upload</v-icon>
                Enviar
              </v-btn>
            </v-col>
          </v-row>

          <v-alert v-if="erroCertificado" type="error" text dense class="mt-2 mb-0">{{ erroCertificado }}</v-alert>

          <v-divider class="my-4"></v-divider>

          <!-- Teste de um GTIN: primeira validacao real da integracao -->
          <div class="d-flex align-center mb-2">
            <v-icon small class="mr-2" color="grey darken-1">mdi-test-tube</v-icon>
            <span class="text-subtitle-2 font-weight-medium">Testar um código de barras</span>
            <span class="text-caption grey--text text--darken-1 ml-2">confirme a integração antes de rodar a varredura inteira</span>
          </div>

          <v-row dense align="center">
            <v-col cols="12" sm="5">
              <v-text-field
                v-model="gtinTeste"
                label="GTIN (código de barras)"
                placeholder="7891962036984"
                outlined
                dense
                hide-details
                :disabled="testando"
                @keyup.enter="testarGtin"
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="3">
              <v-btn block outlined color="teal" :loading="testando" :disabled="!certificado.emUso" @click="testarGtin">
                <v-icon left>mdi-play</v-icon>
                Testar
              </v-btn>
            </v-col>
          </v-row>

          <v-alert v-if="resultadoTeste" :type="resultadoTeste.ncm ? 'success' : 'info'" text dense class="mt-3 mb-0">
            <div class="text-caption">cStat {{ resultadoTeste.cStat }} · {{ resultadoTeste.xMotivo }}</div>
            <template v-if="resultadoTeste.ncm">
              <div class="font-weight-medium mt-1">NCM {{ resultadoTeste.ncm }}<span v-if="resultadoTeste.cest"> · CEST {{ resultadoTeste.cest }}</span></div>
              <div class="text-caption">{{ resultadoTeste.xProd }}</div>
              <div v-if="!resultadoTeste.noIbpt" class="text-caption error--text mt-1">
                Atenção: este NCM não existe na tabela IBPT carregada, então não poderia ser gravado.
              </div>
            </template>
            <div v-else-if="!resultadoTeste.consultavel" class="text-caption mt-1">
              GTIN fora da faixa da GS1 Brasil (789/790) — o serviço não atende esse código, e isso não é falha da integração.
            </div>
            <div class="text-caption grey--text text--darken-1 mt-1">
              assinado por {{ resultadoTeste.certificado.titular || resultadoTeste.certificado.documento }}
              ({{ resultadoTeste.certificado.origem === "painel" ? "certificado do painel" : "certificado de loja cliente" }})
            </div>
          </v-alert>
        </v-sheet>

        <!-- Conferência de NCM -->
        <div class="d-flex align-center flex-wrap mb-3">
          <div>
            <h3 class="text-subtitle-1 font-weight-medium mb-0">Produtos com NCM fora da tabela</h3>
            <span class="text-caption grey--text text--darken-1"> NCM em branco, com menos de 8 dígitos, ou que não existe no IBPT carregado </span>
          </div>
          <v-spacer></v-spacer>
          <v-select v-model="tenantId" :items="inquilinos" item-text="nome" item-value="id" label="Inquilino" outlined dense hide-details clearable style="max-width: 260px" class="mr-4" @change="conferir"></v-select>
          <v-checkbox v-model="incluirInativos" label="Incluir inativos" hide-details dense class="mr-4 mt-0" @change="conferir"></v-checkbox>
          <v-btn color="primary" outlined :loading="conferindo" @click="conferir">
            <v-icon left>mdi-magnify</v-icon>
            Conferir
          </v-btn>
          <v-btn class="ml-2" outlined :disabled="!produtos.length" @click="exportar">
            <v-icon left>mdi-file-excel-outline</v-icon>
            Excel
          </v-btn>
        </div>

        <v-alert v-if="conferencia.message" type="warning" text dense>{{ conferencia.message }}</v-alert>

        <template v-else-if="jaConferiu">
          <v-alert v-if="!produtos.length" type="success" text dense> Nenhum produto com NCM irregular. </v-alert>

          <template v-else>
            <v-alert v-if="conferencia.truncado" type="warning" text dense>
              Mostrando os primeiros {{ conferencia.limite }} produtos. Os botões <strong>"todos"</strong> não se limitam a esta lista — eles agem sobre a base inteira, no servidor. Já os botões de <strong>selecionados</strong> agem só sobre o que está marcado aqui.
            </v-alert>

            <div class="d-flex align-center flex-wrap mb-2">
              <span class="text-caption grey--text text--darken-1">
                {{ conferencia.totais.produtos }} produto(s) em {{ conferencia.totais.clientes }} cliente(s) ·
                <span class="teal--text text--darken-2">{{ comSefaz.length }} pela SEFAZ</span> ·
                <span class="indigo--text">{{ comTabelaConfiavel.length }} pela tabela</span>
                <span v-if="ambiguosTabela.length" class="orange--text text--darken-3"> (+{{ ambiguosTabela.length }} ambígua(s))</span> ·
                <span class="purple--text">{{ comSugestaoIA.length }} pela IA</span> ·
                {{ semRespostaIA.length }} ainda não consultados
              </span>
              <v-spacer></v-spacer>

              <!-- Ordem das origens = ordem de confiabilidade. SEFAZ é consulta
                   ao cadastro do dono da marca; tabela é a hierarquia do NCM já
                   digitado; IA é inferência a partir da descrição. -->
              <v-btn small color="teal" dark class="mr-1 mb-1" :disabled="!selecionadosComSefaz.length" :loading="normalizando" @click="normalizarSefaz(selecionadosComSefaz)">
                <v-icon left small>mdi-barcode</v-icon>
                SEFAZ: selecionados ({{ selecionadosComSefaz.length }})
              </v-btn>
              <v-btn small color="teal" outlined class="mr-4 mb-1" :disabled="!totaisGerais.sefaz || normalizacao.rodando" @click="normalizarTudo('sefaz')">
                todos ({{ totaisGerais.sefaz }})
              </v-btn>

              <v-btn small color="indigo" dark class="mr-1 mb-1" :disabled="!selecionadosComTabela.length" :loading="normalizando" @click="normalizarTabela(selecionadosComTabela)">
                <v-icon left small>mdi-table-search</v-icon>
                Tabela: selecionados ({{ selecionadosComTabela.length }})
              </v-btn>
              <v-btn small color="indigo" outlined class="mr-4 mb-1" :disabled="!totaisGerais.tabela || normalizacao.rodando" @click="normalizarTudo('tabela')" title="Aplica só as leituras inequívocas de toda a base; as ambíguas ficam de fora e podem ser aplicadas pela seleção.">
                todos ({{ totaisGerais.tabela }})
              </v-btn>

              <v-btn small color="purple" dark class="mr-1 mb-1" :disabled="!selecionadosComIA.length" :loading="normalizando" @click="normalizarIA(selecionadosComIA)">
                <v-icon left small>mdi-robot</v-icon>
                IA: selecionados ({{ selecionadosComIA.length }})
              </v-btn>
              <v-btn small color="purple" outlined class="mr-4 mb-1" :disabled="!totaisGerais.ia || normalizacao.rodando" @click="normalizarTudo('ia')">
                todos ({{ totaisGerais.ia }})
              </v-btn>

              <v-btn small text color="purple" class="mr-1 mb-1" :disabled="!semRespostaIA.length" :loading="buscandoIA" @click="buscarIA(false)">
                <v-icon left small>mdi-robot-outline</v-icon>
                Buscar na IA ({{ semRespostaIA.length }})
              </v-btn>
              <v-btn small text color="purple" class="mb-1" :disabled="!semNcmIA.length" :loading="buscandoIA" @click="buscarIA(true)" title="Pergunta de novo para quem a IA não soube responder">
                <v-icon left small>mdi-robot-confused-outline</v-icon>
                Reconsultar vazios ({{ semNcmIA.length }})
              </v-btn>
            </div>

            <!-- Progresso da normalização em massa. Antes ela ia numa
                 requisição só, sem retorno nenhum: parecia travada. -->
            <v-sheet v-if="normalizacao.total || normalizacao.rodando" outlined rounded class="pa-3 mb-3">
              <div class="d-flex align-center">
                <span class="text-subtitle-2 font-weight-medium">
                  Aplicando NCM ({{ normalizacao.origem }})
                </span>
                <v-spacer></v-spacer>
                <v-btn v-if="normalizacao.rodando" small color="error" outlined @click="pararNormalizacao">
                  <v-icon left small>mdi-stop</v-icon>
                  Parar
                </v-btn>
              </div>

              <v-progress-linear :value="progressoNormalizacao" height="22" rounded :color="normalizacao.rodando ? 'green' : 'grey'" class="mt-2">
                <span class="text-caption white--text">{{ normalizacao.processados }} / {{ normalizacao.total }}</span>
              </v-progress-linear>

              <div class="text-caption grey--text text--darken-1 mt-1">
                {{ normalizacao.alterados }} produto(s) atualizado(s) ·
                <span v-if="normalizacao.rodando">em andamento</span>
                <span v-else>concluído</span>
              </div>

              <v-alert v-if="normalizacao.ultimoErro" type="error" text dense class="mt-2 mb-0">{{ normalizacao.ultimoErro }}</v-alert>
            </v-sheet>

            <v-data-table
              v-model="selecionados"
              :headers="headersProdutos"
              :items="produtos"
              :items-per-page="20"
              :footer-props="{ 'items-per-page-text': 'Produtos por página' }"
              item-key="chave"
              show-select
              class="elevation-1"
            >
              <template #[`item.cliente`]="{ item }">
                <div class="font-weight-medium">{{ item.cliente || `Cliente ${item.tenant_id}` }}</div>
                <div v-if="item.cnpjcpf" class="text-caption grey--text text--darken-1">{{ item.cnpjcpf }}</div>
              </template>
              <template #[`item.ncm`]="{ item }">
                <span v-if="item.ncm" class="error--text">{{ item.ncm }}</span>
                <span v-else class="grey--text">(vazio)</span>
              </template>
              <template #[`item.codigo_barras`]="{ item }">
                <span v-if="item.codigo_barras">{{ item.codigo_barras }}</span>
                <span v-else class="grey--text">(sem código)</span>
                <div v-if="item.codigo_barras && !item.gtin_consultavel" class="text-caption grey--text" title="A SEFAZ só publica GTIN da GS1 Brasil (prefixo 789/790). Código interno de loja e importado não respondem.">
                  fora da GS1 Brasil
                </div>
              </template>
              <template #[`item.ncm_sefaz`]="{ item }">
                <template v-if="item.ncm_sefaz">
                  <div class="font-weight-medium teal--text text--darken-2">{{ item.ncm_sefaz }}</div>
                  <div class="text-caption grey--text text--darken-1">{{ item.descricao_sefaz }}</div>
                </template>
                <span v-else-if="item.sefaz_consultada" class="grey--text" :title="item.motivo_sefaz">SEFAZ não tem este GTIN</span>
                <span v-else-if="!item.gtin_consultavel" class="grey--text">GTIN não atendido</span>
                <span v-else class="grey--text">não consultado</span>
              </template>
              <template #[`item.ncm_tabela`]="{ item }">
                <template v-if="item.ncm_tabela">
                  <div class="font-weight-medium" :class="item.ambiguo_tabela ? 'orange--text text--darken-3' : 'indigo--text'">
                    {{ item.ncm_tabela }}
                  </div>
                  <div class="text-caption grey--text text--darken-1">{{ item.descricao_tabela }}</div>
                  <!-- Quantos dígitos casaram é a medida de confiança: 6 é
                       subposição (estreito), 4 é posição (largo). -->
                  <div class="text-caption" :class="item.prefixo_tabela.length >= 6 ? 'grey--text' : 'orange--text text--darken-2'">
                    casou {{ item.prefixo_tabela.length }} dígitos ({{ item.prefixo_tabela }})
                  </div>
                  <!-- O número admite leitura em outro capítulo. Foi assim que
                       um cominho recebeu NCM de relojoaria: 00910900 lê tanto
                       0910 (especiarias) quanto 9109 (relógios). -->
                  <div v-if="item.ambiguo_tabela" class="text-caption orange--text text--darken-3 font-weight-medium" title="O número admite leitura em outro capítulo da NCM. Confira antes de aplicar — ou use SEFAZ/IA neste item.">
                    <v-icon x-small color="orange darken-3">mdi-alert-outline</v-icon>
                    leitura ambígua — confira
                  </div>
                </template>
                <span v-else class="grey--text">sem correspondência</span>
              </template>
              <template #[`item.ncm_ia`]="{ item }">
                <template v-if="item.ncm_ia">
                  <div class="font-weight-medium purple--text">{{ item.ncm_ia }}</div>
                  <div class="text-caption grey--text text--darken-1">{{ item.descricao_ia }}</div>
                </template>
                <span v-else-if="item.ia_consultada" class="grey--text">IA não soube dizer</span>
                <span v-else class="grey--text">não consultado</span>
              </template>
              <template #[`item.motivo`]="{ item }">
                <v-chip x-small :color="item.motivo === 'NCM em branco' ? 'error' : 'warning'" dark>{{ item.motivo }}</v-chip>
              </template>
            </v-data-table>
          </template>
        </template>
      </v-card-text>
    </v-card>

    <!-- Upload -->
    <v-dialog v-model="dialogUpload" max-width="600" persistent>
      <v-card>
        <v-card-title>Enviar tabela IBPT</v-card-title>
        <v-card-text>
          <p class="text-body-2 grey--text text--darken-1">Envie o arquivo <strong>.csv</strong> publicado pelo IBPT. A tabela atual é substituída por completo.</p>

          <v-file-input v-model="arquivo" accept=".csv" label="Arquivo do IBPT" prepend-icon="mdi-file-delimited-outline" outlined dense show-size :error-messages="erroArquivo" :disabled="enviando"></v-file-input>

          <v-progress-linear v-if="enviando" :value="progresso" height="20" rounded color="primary" class="mt-2">
            <span class="text-caption">{{ progresso }}%</span>
          </v-progress-linear>
          <div v-if="enviando && progresso >= 100" class="text-caption grey--text mt-1">Processando as 12 mil linhas no servidor...</div>
        </v-card-text>
        <v-card-actions class="px-6 pb-4">
          <v-spacer></v-spacer>
          <v-btn text :disabled="enviando" @click="fecharUpload">Cancelar</v-btn>
          <v-btn color="primary" depressed :loading="enviando" @click="enviar">Enviar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-snackbar v-model="snackbar" :color="snackbarCor" timeout="6000">{{ mensagem }}</v-snackbar>
  </MenuAdmin>
</template>

<script>
import MenuAdmin from "@/components/Admin/Menu/MenuAdmin.vue";
import { gerarExcel } from "@/utils/exports";

export default {
  name: "IbptAdmin",
  components: { MenuAdmin },
  data() {
    return {
      carregando: false,
      conferindo: false,
      jaConferiu: false,
      dialogUpload: false,
      enviando: false,
      progresso: 0,
      arquivo: null,
      erroArquivo: "",
      incluirInativos: false,
      tenantId: null,
      zeroTotal: null,
      contandoZero: false,
      corrigindoZero: false,
      buscandoIA: false,
      iniciandoMutirao: false,
      mutiraoReconsultar: false,
      mutirao: { rodando: false, total: 0, processados: 0, comSugestao: 0, tentativas: 0, ultimoErro: "", cotaDiaria: false },
      timerMutirao: null,
      sefaz: { rodando: false, total: 0, processados: 0, comNcm: 0, ultimoErro: "", bloqueado: false },
      iniciandoSefaz: false,
      timerSefaz: null,
      normalizacao: { rodando: false, origem: "", total: 0, processados: 0, alterados: 0, ultimoErro: "" },
      timerNormalizacao: null,
      certificado: { temProprio: false, emUso: null },
      certificadoArquivo: null,
      certificadoSenha: "",
      enviandoCertificado: false,
      erroCertificado: "",
      gtinTeste: "",
      testando: false,
      resultadoTeste: null,
      selecionados: [],
      normalizando: false,
      snackbar: false,
      snackbarCor: "success",
      mensagem: "",
      headersProdutos: [
        { text: "Cliente", value: "cliente" },
        { text: "Código", value: "codigo", width: 100 },
        { text: "GTIN", value: "codigo_barras", width: 150 },
        { text: "Descrição", value: "descricao" },
        { text: "NCM atual", value: "ncm", width: 110 },
        // A SEFAZ vem antes da IA de propósito: é consulta ao cadastro do dono
        // da marca, não palpite. Quando as duas respondem, é a que vale.
        { text: "NCM da SEFAZ", value: "ncm_sefaz", width: 260 },
        { text: "Sugestão pela tabela", value: "ncm_tabela", width: 260 },
        { text: "Sugestão da IA", value: "ncm_ia", width: 260 },
        { text: "Motivo", value: "motivo", width: 200 },
      ],
    };
  },
  computed: {
    situacao() {
      return this.$store.state.ibpt.ibptSituacao;
    },
    conferencia() {
      return this.$store.state.ibpt.ibptProdutosSemNcm;
    },
    produtos() {
      // Chave propria: produto e identificado por (tenant, codigo, barras), e a
      // grid precisa de um item-key unico para a selecao funcionar.
      return (this.conferencia.produtos || []).map((produto) => ({
        ...produto,
        chave: `${produto.tenant_id}|${produto.codigo}|${produto.codigo_barras}`,
      }));
    },
    selecionadosComIA() {
      return this.selecionados.filter((produto) => !!produto.ncm_ia);
    },
    // Ainda não perguntados à IA. Quem já foi e voltou vazio não entra: seria
    // pagar de novo pela mesma resposta.
    semRespostaIA() {
      return this.produtos.filter((produto) => !produto.ia_consultada && produto.descricao);
    },
    comSugestaoIA() {
      return this.produtos.filter((produto) => !!produto.ncm_ia);
    },
    // Já consultados e sem resposta. Ficam de fora da busca normal para não
    // pagar duas vezes pelo mesmo silêncio, mas podem ser reconsultados.
    semNcmIA() {
      return this.produtos.filter((produto) => produto.ia_consultada && !produto.ncm_ia);
    },
    // Quantos a base INTEIRA resolveria por origem. O que está na tela é no
    // máximo LIMITE_CONFERENCIA; usar a contagem da tela nos botões de "todos"
    // prometia menos do que o servidor faz.
    totaisGerais() {
      return this.conferencia.totaisGerais || { sefaz: 0, tabela: 0, ia: 0 };
    },
    progressoNormalizacao() {
      if (!this.normalizacao.total) return 0;
      return Math.round((this.normalizacao.processados / this.normalizacao.total) * 100);
    },
    selecionadosComTabela() {
      return this.selecionados.filter((produto) => !!produto.ncm_tabela);
    },
    comTabela() {
      return this.produtos.filter((produto) => !!produto.ncm_tabela);
    },
    // O "aplicar em todos" só age sobre o inequívoco. O ambíguo continua
    // aplicável pela seleção, que é uma escolha explícita de quem olhou.
    comTabelaConfiavel() {
      return this.produtos.filter((produto) => produto.ncm_tabela && !produto.ambiguo_tabela);
    },
    ambiguosTabela() {
      return this.produtos.filter((produto) => produto.ncm_tabela && produto.ambiguo_tabela);
    },
    selecionadosComSefaz() {
      return this.selecionados.filter((produto) => !!produto.ncm_sefaz);
    },
    comSefaz() {
      return this.produtos.filter((produto) => !!produto.ncm_sefaz);
    },
    progressoSefaz() {
      if (!this.sefaz.total) return 0;
      return Math.round((this.sefaz.processados / this.sefaz.total) * 100);
    },
    progressoMutirao() {
      if (!this.mutirao.total) return 0;
      return Math.round((this.mutirao.processados / this.mutirao.total) * 100);
    },
    inquilinos() {
      return (this.$store.state.admin.tenantList.tenantList || []).map((tenant) => ({
        id: tenant.id,
        nome: `${tenant.id} - ${tenant.name || tenant.user}`,
      }));
    },
    // A tabela do IBPT é trimestral; passada a vigência, os percentuais deixam
    // de valer mesmo que a consulta de NCM continue funcionando.
    vigenciaVencida() {
      const fim = this.situacao?.carga?.vigenciaFim;
      if (!fim) return false;
      return String(fim).substring(0, 10) < new Date().toISOString().substring(0, 10);
    },
  },
  async mounted() {
    this.carregando = true;
    try {
      await Promise.all([this.$store.dispatch("getIbptSituacao"), this.$store.dispatch("getAdminTenantList")]);
      // O mutirão pode já estar rodando de uma sessão anterior.
      await Promise.all([this.atualizarMutirao(), this.atualizarSefaz(), this.atualizarCertificado(), this.atualizarNormalizacao()]);
    } finally {
      this.carregando = false;
    }
  },
  beforeDestroy() {
    clearTimeout(this.timerMutirao);
    clearTimeout(this.timerSefaz);
    clearTimeout(this.timerNormalizacao);
  },
  methods: {
    formatarData(data) {
      if (!data) return "-";
      const [ano, mes, dia] = String(data).substring(0, 10).split("-");
      return `${dia}/${mes}/${ano}`;
    },
    formatarDataHora(data) {
      if (!data) return "-";
      return new Date(data).toLocaleString("pt-BR");
    },
    avisar(mensagem, cor = "success") {
      this.mensagem = mensagem;
      this.snackbarCor = cor;
      this.snackbar = true;
    },
    fecharUpload() {
      this.dialogUpload = false;
      this.arquivo = null;
      this.erroArquivo = "";
      this.progresso = 0;
    },
    async enviar() {
      this.erroArquivo = "";
      if (!this.arquivo) {
        this.erroArquivo = "Selecione o arquivo .csv do IBPT.";
        return;
      }

      this.enviando = true;
      this.progresso = 0;
      try {
        const resposta = await this.$store.dispatch("publicarIbpt", {
          arquivo: this.arquivo,
          onProgress: (evento) => {
            this.progresso = evento.total ? Math.round((evento.loaded * 100) / evento.total) : 0;
          },
        });
        this.fecharUpload();
        const descartados = resposta.ignorados ? ` ${resposta.ignorados} código(s) de serviço do arquivo foram ignorados.` : "";
        this.avisar(`${resposta.message} ${resposta.registros} NCM carregados (versão ${resposta.versao}).${descartados}`);
        // A conferência anterior fala da tabela antiga: refaz se já havia uma.
        if (this.jaConferiu) await this.conferir();
      } catch (erro) {
        this.erroArquivo = erro?.response?.data?.message || "Não foi possível processar o arquivo.";
      } finally {
        this.enviando = false;
      }
    },
    async contarZero() {
      this.contandoZero = true;
      try {
        const res = await this.$store.dispatch("contarZeroAEsquerda", this.tenantId ? { tenant_id: this.tenantId } : {});
        this.zeroTotal = res.total;
      } finally {
        this.contandoZero = false;
      }
    },
    async corrigirZero() {
      const alvo = this.tenantId ? "do inquilino selecionado" : "de TODOS os inquilinos";
      if (!window.confirm(`Completar o zero à esquerda em ${this.zeroTotal} produto(s) ${alvo}?`)) return;

      this.corrigindoZero = true;
      try {
        const res = await this.$store.dispatch("corrigirZeroAEsquerda", this.tenantId ? { tenant_id: this.tenantId } : {});
        this.avisar(`${res.alterados} produto(s) corrigido(s).`);
        await this.contarZero();
        if (this.jaConferiu) await this.conferir();
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível corrigir.", "error");
      } finally {
        this.corrigindoZero = false;
      }
    },
    async atualizarMutirao() {
      try {
        this.mutirao = await this.$store.dispatch("getMutiraoIA");
      } catch {
        // Painel sem resposta não pode derrubar a tela.
      }

      clearTimeout(this.timerMutirao);
      // Só continua perguntando enquanto houver o que acompanhar.
      if (this.mutirao.rodando) this.timerMutirao = setTimeout(() => this.atualizarMutirao(), 5000);
    },
    async iniciarMutirao() {
      if (!window.confirm("Iniciar o mutirão de NCM por IA?\n\nEle percorre os produtos de todos os inquilinos e continua rodando no servidor mesmo com esta tela fechada.")) return;

      this.iniciandoMutirao = true;
      try {
        await this.$store.dispatch("iniciarMutiraoIA", { reconsultarVazios: this.mutiraoReconsultar });
        await this.atualizarMutirao();
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível iniciar.", "error");
      } finally {
        this.iniciandoMutirao = false;
      }
    },
    async pararMutirao() {
      await this.$store.dispatch("pararMutiraoIA");
      this.avisar("O mutirão vai parar ao terminar o lote atual.");
      await this.atualizarMutirao();
    },

    async atualizarSefaz() {
      try {
        this.sefaz = await this.$store.dispatch("getSefazGtin");
      } catch {
        // Painel sem resposta não pode derrubar a tela.
      }

      clearTimeout(this.timerSefaz);
      if (this.sefaz.rodando) this.timerSefaz = setTimeout(() => this.atualizarSefaz(), 5000);
    },
    async iniciarSefaz() {
      if (!window.confirm("Buscar o NCM na SEFAZ pelo código de barras?\n\nUsa o certificado digital de uma loja cadastrada e percorre os GTIN de todos os inquilinos. Continua rodando no servidor com esta tela fechada.")) return;

      this.iniciandoSefaz = true;
      try {
        await this.$store.dispatch("iniciarSefazGtin");
        await this.atualizarSefaz();
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível iniciar a busca na SEFAZ.", "error");
      } finally {
        this.iniciandoSefaz = false;
      }
    },
    async pararSefaz() {
      await this.$store.dispatch("pararSefazGtin");
      this.avisar("A busca na SEFAZ vai parar na próxima consulta.");
      await this.atualizarSefaz();
    },
    async atualizarCertificado() {
      try {
        this.certificado = await this.$store.dispatch("getCertificadoSefaz");
      } catch {
        // Painel sem resposta não pode derrubar a tela.
      }
    },
    async enviarCertificado() {
      this.erroCertificado = "";

      if (!this.certificadoArquivo) {
        this.erroCertificado = "Selecione o certificado A1 (.pfx ou .p12).";
        return;
      }
      if (!this.certificadoSenha) {
        this.erroCertificado = "Informe a senha do certificado.";
        return;
      }

      this.enviandoCertificado = true;
      try {
        const resposta = await this.$store.dispatch("enviarCertificadoSefaz", {
          arquivo: this.certificadoArquivo,
          senha: this.certificadoSenha,
        });

        // A senha nao fica na tela depois de enviada.
        this.certificadoArquivo = null;
        this.certificadoSenha = "";

        this.avisar(`Certificado de ${resposta.titular} cadastrado.`);
        await this.atualizarCertificado();
      } catch (erro) {
        this.erroCertificado = erro?.response?.data?.message || "Não foi possível ler o certificado.";
      } finally {
        this.enviandoCertificado = false;
      }
    },
    async removerCertificado() {
      if (!window.confirm("Remover o certificado do painel?\n\nSem ele, as consultas passam a usar o certificado de uma loja cliente.")) return;

      try {
        await this.$store.dispatch("removerCertificadoSefaz");
        this.avisar("Certificado removido.");
        await this.atualizarCertificado();
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível remover.", "error");
      }
    },
    async testarGtin() {
      this.resultadoTeste = null;
      this.testando = true;
      try {
        this.resultadoTeste = await this.$store.dispatch("testarSefazGtin", this.gtinTeste);
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível consultar a SEFAZ.", "error");
      } finally {
        this.testando = false;
      }
    },
    async atualizarNormalizacao() {
      try {
        this.normalizacao = await this.$store.dispatch("getNormalizacao");
      } catch {
        // Painel sem resposta não pode derrubar a tela.
      }

      clearTimeout(this.timerNormalizacao);
      if (this.normalizacao.rodando) {
        this.timerNormalizacao = setTimeout(() => this.atualizarNormalizacao(), 2000);
      } else if (this.normalizacao.total) {
        // Terminou: recarrega a conferência para a lista refletir o que foi
        // gravado, senão os produtos já corrigidos continuariam na tela.
        await this.conferir();
      }
    },
    // Aplica sobre a BASE INTEIRA, no servidor. Diferente dos botões de
    // seleção, que agem só sobre o que o operador marcou na tela.
    async normalizarTudo(origem) {
      const quantos = this.totaisGerais[origem] || 0;
      const nomes = { sefaz: "consultado na SEFAZ", tabela: "deduzido pela tabela IBPT", ia: "sugerido pela IA" };

      if (!window.confirm(`Gravar o NCM ${nomes[origem]} em ${quantos} produto(s) de todos os inquilinos${this.tenantId ? " do filtro atual" : ""}?

A alteração não pode ser desfeita. O processo roda no servidor e você pode fechar esta tela.`)) return;

      try {
        await this.$store.dispatch("iniciarNormalizacaoTudo", {
          origem,
          ...(this.tenantId ? { tenant_id: this.tenantId } : {}),
          incluirInativos: this.incluirInativos ? "1" : "0",
        });
        await this.atualizarNormalizacao();
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível iniciar a normalização.", "error");
      }
    },
    async pararNormalizacao() {
      await this.$store.dispatch("pararNormalizacao");
      this.avisar("A normalização vai parar ao terminar o lote atual.");
      await this.atualizarNormalizacao();
    },
    // Grava o NCM deduzido pela hierarquia da própria tabela do IBPT.
    normalizarTabela(itens) {
      return this.normalizar(
        itens.map((produto) => ({ ...produto, ncm_sugerido: produto.ncm_tabela })),
        "sugerido pela tabela IBPT"
      );
    },
    // Grava o NCM que a SEFAZ devolveu, no mesmo caminho validado da IA.
    normalizarSefaz(itens) {
      return this.normalizar(
        itens.map((produto) => ({ ...produto, ncm_sugerido: produto.ncm_sefaz })),
        "da SEFAZ"
      );
    },
    async buscarIA(reconsultar) {
      const alvo = reconsultar ? this.semNcmIA : this.semRespostaIA;
      const texto = reconsultar ? "Perguntar de novo para" : "Consultar a IA para";
      if (!window.confirm(`${texto} ${alvo.length} produto(s)?

A resposta fica gravada, então a conferência seguinte já vem preenchida.`)) return;

      this.buscandoIA = true;
      try {
        const res = await this.$store.dispatch("buscarNcmComIA", {
          produtos: alvo.map((item) => ({ descricao: item.descricao })),
          reconsultarVazios: reconsultar,
        });
        const sobra = res.restantes ? ` ${res.restantes} ficaram para a próxima rodada.` : "";
        // Falha parcial não é erro: o que respondeu já está gravado e some da
        // próxima rodada. Basta clicar de novo para pegar o que faltou.
        const falha = res.falharam ? ` ${res.falharam} falharam (${res.erro}) — clique de novo para tentar só essas.` : "";

        this.avisar(res.message || `${res.consultados} descrição(ões) consultada(s), ${res.comSugestao} com NCM.${sobra}${falha}`, res.falharam ? "warning" : "success");
        await this.conferir();
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível consultar a IA.", "error");
      } finally {
        this.buscandoIA = false;
      }
    },
    // Grava o NCM que a IA escolheu, no mesmo caminho validado da normalização.
    normalizarIA(itens) {
      return this.normalizar(itens.map((produto) => ({ ...produto, ncm_sugerido: produto.ncm_ia })));
    },
    async conferir() {
      this.conferindo = true;
      try {
        this.selecionados = [];
        await this.$store.dispatch("getIbptProdutosSemNcm", {
          incluirInativos: this.incluirInativos ? "1" : "0",
          ...(this.tenantId ? { tenant_id: this.tenantId } : {}),
        });
        this.jaConferiu = true;
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível conferir os NCM.", "error");
      } finally {
        this.conferindo = false;
      }
    },
    // Grava o NCM sugerido nos produtos indicados. Confirma antes: e alteracao
    // de dado fiscal, em cadastro de cliente, e nao tem desfazer.
    async normalizar(itens, origem = "sugerido pela IA") {
      if (!itens.length) return;

      const clientes = new Set(itens.map((item) => item.tenant_id)).size;
      const confirmado = window.confirm(`Gravar o NCM ${origem} em ${itens.length} produto(s) de ${clientes} cliente(s)?

A alteração não pode ser desfeita.`);
      if (!confirmado) return;

      this.normalizando = true;
      try {
        const resposta = await this.$store.dispatch(
          "normalizarNcm",
          itens.map((item) => ({
            tenant_id: item.tenant_id,
            codigo: item.codigo,
            codigo_barras: item.codigo_barras,
            ncm: item.ncm_sugerido,
          }))
        );

        const recusados = resposta.rejeitados?.length ? ` ${resposta.rejeitados.length} recusado(s).` : "";
        this.avisar(`${resposta.alterados} produto(s) atualizado(s).${recusados}`, resposta.rejeitados?.length ? "warning" : "success");

        await this.conferir();
      } catch (erro) {
        this.avisar(erro?.response?.data?.message || "Não foi possível normalizar.", "error");
      } finally {
        this.normalizando = false;
      }
    },
    exportar() {
      const linhas = this.produtos.map((produto) => ({
        cliente: produto.cliente,
        cnpjcpf: produto.cnpjcpf,
        codigo: produto.codigo,
        codigo_barras: produto.codigo_barras,
        descricao: produto.descricao,
        ncm: produto.ncm,
        ncm_sefaz: produto.ncm_sefaz,
        descricao_sefaz: produto.descricao_sefaz,
        ncm_tabela: produto.ncm_tabela,
        descricao_tabela: produto.descricao_tabela,
        prefixo_tabela: produto.prefixo_tabela,
        ambiguo_tabela: produto.ambiguo_tabela ? "SIM" : "",
        ncm_ia: produto.ncm_ia,
        descricao_ia: produto.descricao_ia,
        motivo: produto.motivo,
      }));
      gerarExcel(linhas, "produtos_ncm_irregular.xlsx");
    },
  },
};
</script>

<style scoped>
.cabecalho {
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}
</style>
