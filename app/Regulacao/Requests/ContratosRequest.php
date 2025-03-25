<?php

namespace App\Regulacao\Requests;

use App\Traits\ACL;
use Illuminate\Foundation\Http\FormRequest;

class ContratosRequest extends FormRequest
{
    use ACL;

    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return $this->can('Contratos Criar', 'Contratos Editar');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'contrato' => 'max:25',
            'ano' => 'max:4|date_format:Y',
            'contratada_nome' => 'required|max:255',
            'contratada_cnpj' => 'required|cnpj',
            'vigencia_inicio' => 'required|date_format:Y-m-d',
            'vigencia_fim' => 'required|date_format:Y-m-d',
            'descricao' => 'required|max:550',
            'ativo' => 'required',
            'valor_global' => 'required|decimal:0,2',
            'contratante' => 'required|max:255',
            'versao' => 'required|max:2'
        ];
    }

    public function messages(): array
    {
        return [];
    }
}
