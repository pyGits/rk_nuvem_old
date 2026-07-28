import * as Firebird from "node-firebird";

class SyspdvConnection {
  private options: Firebird.Options;
  private db: Firebird.Database | null = null; // conexão ativa

  constructor(options?: Firebird.Options) {
    this.options = options || {};
    this.options.database = "c:\\syspdv\\syspdv_srv.fdb";
    this.options.user = "SYSDBA";
    this.options.password = "masterkey";
    this.options.host = "127.0.0.1";
    this.options.port = 3050;
    // this.options.encoding = "GBK";
    this.options.encoding = "UTF8";

    // inicia conexão automaticamente
    // try {
    // this.init();
    // } catch (error) {}
  }

  private async init() {
    try {
      this.db = await this.connect();
      console.log("🔥 Conexão Firebird 2já estabelecida!");
    } catch (err) {
      console.error("❌ Erro ao conectar no Firebird:", err);
    }
  }

  private async connect(): Promise<Firebird.Database> {
    if (this.db) return this.db; // reutiliza conexão se já existir
    return new Promise<Firebird.Database>((resolve, reject) => {
      Firebird.attach(this.options, (err: any, db: Firebird.Database) => {
        if (err) {
          reject(err);
        } else {
          this.db = db;
          resolve(db);
        }
      });
    });
  }

  async disconnect(): Promise<void> {
    if (!this.db) return;

    return new Promise<void>((resolve, reject) => {
      this.db!.detach((err) => {
        if (err) {
          reject(err);
        } else {
          this.db = null;
          resolve();
        }
      });
    });
  }

  async executeQuery(sql: string, params?: any[]): Promise<any[]> {
    const db = await this.connect(); // já retorna a instância conectada
    return new Promise<any[]>((resolve, reject) => {
      db.query(sql, params || [], (err, result) => {
        if (err) return reject(err);

        const trimmedResult = result.map((row) => {
          return Object.keys(row).reduce((acc, key) => {
            acc[key] = typeof row[key] === "string" ? row[key].trim() : row[key];
            return acc;
          }, {} as any);
        });
        resolve(trimmedResult);
      });
    });
  }

  async executeStatement(sql: string, params?: any[]): Promise<void> {
    const db = await this.connect();
    return new Promise<void>((resolve, reject) => {
      db.transaction(Firebird.ISOLATION_READ_COMMITTED, (err, transaction) => {
        if (err) return reject(err);

        transaction.query(sql, params || [], (err) => {
          if (err) {
            transaction.rollback(() => reject(err));
          } else {
            transaction.commit((err) => {
              if (err) {
                transaction.rollback(() => reject(err));
              } else {
                resolve();
              }
            });
          }
        });
      });
    });
  }
}

const singleton = new SyspdvConnection();
export default singleton;
