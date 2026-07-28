export interface FieldError {
  field: string;
  message: string;
}

export class CustomError extends Error {
  private errors: FieldError[] = [];

  constructor(initialErrors?: FieldError[]) {
    super("Erro de validação!");
    this.name = "CustomError";

    if (initialErrors && Array.isArray(initialErrors)) {
      this.errors = [...initialErrors];
    }

    // Necessário para estender Error corretamente no TypeScript
    Object.setPrototypeOf(this, CustomError.prototype);
  }

  add(error: FieldError): void {
    this.errors.push(error);
  }

  addMany(errors: FieldError[]): void {
    this.errors.push(...errors);
  }

  getAll(): FieldError[] {
    return this.errors;
  }

  getByField(field: string): FieldError[] {
    return this.errors.filter((err) => err.field === field);
  }

  getFirstMessage(field: string): string | null {
    const found = this.errors.find((err) => err.field === field);
    return found ? found.message : null;
  }

  hasErrors(): boolean {
    return this.errors.length > 0;
  }

  hasError(field: string): boolean {
    return this.errors.some((err) => err.field === field);
  }

  clear(): void {
    this.errors = [];
  }

  toString(): string {
    return this.errors.map((err) => `${err.field}: ${err.message}`).join(", ");
  }
}
