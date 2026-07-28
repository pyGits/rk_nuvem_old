import * as Firebird from "node-firebird";

export default class FirebirdConnection {
  private options: Firebird.Options;

  constructor(options?: Firebird.Options) {
    this.options = options || {};
    this.options.database = "c:\\system_rk\\server\\bd\\banco.fdb";
    this.options.user = "SYSDBA";
    this.options.password = "masterkey";
    this.options.host = "127.0.0.1";
    this.options.port = 3050;
    this.options.encoding = "GBK";
  }

  async connect(): Promise<Firebird.Database> {
    return new Promise<Firebird.Database>((resolve, reject) => {
      Firebird.attach(this.options, (err: any, db: Firebird.Database) => {
        if (err) {
          reject(err);
        } else {
          resolve(db);
        }
      });
    });
  }

  async disconnect(db: Firebird.Database): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      db.detach((err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
  }

  async executeQuery(sql: string, params?: any[]): Promise<any[]> {
    const db: Firebird.Database = await this.connect();
    return new Promise<any[]>((resolve, reject) => {
      db.query(sql, params || [], (err, result) => {
        this.disconnect(db)
          .then(() => {
            if (err) {
              reject(err);
            } else {
              // Aplicando TRIM() nos valores retornados
              const trimmedResult = result.map((row) => {
                return Object.keys(row).reduce((acc, key) => {
                  acc[key] = typeof row[key] === "string" ? row[key].trim() : row[key];
                  return acc;
                }, {});
              });
              resolve(trimmedResult);
            }
          })
          .catch(reject);
      });
    });
  }

  async executeStatement(sql: string, params?: any[]): Promise<void> {
    const db: Firebird.Database = await this.connect();
    return new Promise<void>((resolve, reject) => {
      db.transaction(Firebird.ISOLATION_READ_COMMITTED, (err, transaction) => {
        if (err) {
          this.disconnect(db)
            .then(() => reject(err))
            .catch(reject);
          return;
        }

        transaction.query(sql, params || [], (err) => {
          if (err) {
            transaction.rollback(() => {
              this.disconnect(db)
                .then(() => reject(err))
                .catch(reject);
            });
          } else {
            transaction.commit((err) => {
              if (err) {
                transaction.rollback(() => {
                  this.disconnect(db)
                    .then(() => reject(err))
                    .catch(reject);
                });
              } else {
                this.disconnect(db).then(resolve).catch(reject);
              }
            });
          }
        });
      });
    });
  }
}
