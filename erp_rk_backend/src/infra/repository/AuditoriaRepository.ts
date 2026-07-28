import DatabaseConnection from "./DatabaseConnection";

 class AuditoriaRepoistory{
    async insert(tabela:string,coluna:string,valor:string,valor_anterior:string,operacao:string,tenant_id:number){
        await DatabaseConnection.query('INSERT INTO auditoria (tabela,coluna,valor,valor_anterior,data,operacao,tenant_id) values($1,$2,$3,$4,now(),$5,$6)',[
            tabela,
            coluna,
            valor,
            valor_anterior,
            operacao,
            tenant_id
        ])
    }
}
export default new AuditoriaRepoistory()