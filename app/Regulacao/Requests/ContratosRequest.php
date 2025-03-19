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
        //$req = $this;
        return [
            'contrato' => 'max:25',
            'ano' => 'max:4',
            'contratada_nome' => 'required|max:255',
            'contratada_cnpj' => 'required|cnpj',
            'cigencia_inicio' => 'required|date_format:Y-m-d',
            'vigencia_fim' => 'required|date_format:Y-m-d',
            'descricao' => 'required|max:255',
            'ativo' => 'required',
        ];
    }

    public function messages(): array
    {
        return [];
    }
}
