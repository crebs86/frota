<?php

namespace App\Frota\Requests;

use App\Traits\ACL;
use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class RequestRequest extends FormRequest
{
    use ACL;

    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return $this->can('Solicitacao Criar', 'Solicitacao Editar');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */

    public function rules(): array
    {
        return [
            'branch' => 'required|integer|exists:branches,id',
            'time' => 'required|date_format:H:i:s',
            'duration' => 'required|date_format:H:i',
            'date' => 'required|date|date_format:Y-m-d',
            'driver' => 'required|integer|exists:drivers,id',
            'local' => 'required_if:branch,==,1|string|nullable|max:255',
            'passengers' => 'nullable|array'
        ];
    }

    public function messages(): array
    {
        return [
            'branch.*' => 'Informe uma unidade para a rota.',
            'time.required' => 'Selecione um horário para a rota.',
            'time.date_format' => 'Selecione um horário na lista.',
            'duration.required' => 'Informe a duração.',
            'duration.date_format' => 'Duração inválida.',
            'date.*' => 'A data não foi informada.',
            'driver.*' => 'Selecione um motorista para fazer a rota.',
            'local.required_if' => 'O campo Local é obrigatório quando unidade Não Cadastrada.'
        ];
    }
}
