import Vue from "vue";
import { AxiosError } from "axios";
import ToastService from "./ToastService";
import { CustomError } from "../entity/CustomError";

// Interface do erro individual
export interface FieldError {
  field: string;
  message: string;
}

// Estado reativo com observable do Vue
const state = Vue.observable({
  errors: [] as FieldError[],
});

const ErrorService = {
  addError(error: FieldError): void {
    state.errors.push(error);
    ToastService.showError(error.message);
  },

  clearErrorByField(field: string): void {
    state.errors = state.errors.filter((err) => err.field !== field);
  },

  getFirstErrorByField(field: string): string | null {
    const found = state.errors.find((err) => err.field === field);
    return found ? found.message : null;
  },

  hasError(field: string): boolean {
    return state.errors.some((err) => err.field === field);
  },

  clearAll(): void {
    state.errors = [];
  },

  getAllErrors(): FieldError[] {
    return state.errors;
  },

  showError(error: unknown): void {
    if (error instanceof AxiosError) {
      const message = error.response?.data?.message || "Erro de requisição";
      this.addError({ field: "", message });
    } else if (error instanceof CustomError) {
      for (const err of error.getAll()) {
        this.addError({ field: err.field, message: err.message });
      }
    } else if (error instanceof Error) {
      this.addError({ field: "", message: error.message });
    } else if (typeof error === "string") {
      this.addError({ field: "", message: error });
    }
  },
};

export default ErrorService;
