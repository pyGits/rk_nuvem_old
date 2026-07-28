import { AxiosResponse } from "axios";
import Vue from "vue";
class Connection {
  async post(endpoint: string, data: any): Promise<any> {
    return await Vue.prototype.$http.post(endpoint, data);
  }
  async delete(endpoint: string): Promise<any> {
    return await Vue.prototype.$http.delete(endpoint);
  }
  async put(endpoint: string, data?: any): Promise<any> {
    return await Vue.prototype.$http.put(endpoint, data);
  }
  async get(endpoint: string, config: any = {}): Promise<any> {
    return Vue.prototype.$http.get(endpoint, {
      ...config,
      params: config.params || {}, // garante que 'params' pode ser passado
    });
  }
  async uploadFile<T>(endpoint: string, file: File, fieldName = "file"): Promise<AxiosResponse<any>> {
    const formData = new FormData();
    formData.append(fieldName, file);

    return await Vue.prototype.$http.post(endpoint, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
  }
  async uploadFormData<T>(endpoint: string, formData: FormData): Promise<AxiosResponse<any>> {
    return await Vue.prototype.$http.post(endpoint, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });
  }
}
// Exporta uma instância da classe Connection com a URL base
export default new Connection();
