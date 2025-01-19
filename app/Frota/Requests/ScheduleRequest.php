<?php

namespace App\Frota\Requests;

use App\Traits\ACL;
use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class ScheduleRequest extends FormRequest
{
    use ACL;

    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return $this->can('Agenda Criar', 'Agenda Editar');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        $req = $this;
        return [
            'driver_id' => ['int', "nullable", Rule::exists('drivers', 'id')],
            'timeMorningStart' => ['nullable', Rule::requiredIf(function () use ($req) {
                return $req->timeMorningEnd;
            })],
            'timeMorningEnd' => ['nullable', Rule::requiredIf(function () use ($req) {
                return $req->timeMorningStart;
            })],
            'timeAfternoonStart' => ['nullable', Rule::requiredIf(function () use ($req) {
                return $req->timeAfternoonEnd;
            })],
            'timeAfternoonEnd' => ['nullable', Rule::requiredIf(function () use ($req) {
                return $req->timeAfternoonStart;
            })],
            'timeNightStart' => ['nullable', Rule::requiredIf(function () use ($req) {
                return $req->timeNightEnd;
            })],
            'timeNightEnd' => ['nullable', Rule::requiredIf(function () use ($req) {
                return $req->timeNightStart;
            })],
            'timeSpecialStart' => ['nullable', Rule::requiredIf(function () use ($req) {
                return $req->timeSpecialEnd;
            })],
            'timeSpecialEnd' => ['nullable', Rule::requiredIf(function () use ($req) {
                return $req->timeSpecialStart;
            })],
        ];
    }

    public function messages(): array
    {
        return [
            'driver_id.exists' => 'Selecione um motorista',
            'timeMorningStart.required' => 'Informe a hora INICIAL da manhã',
            'timeAfternoonStart.required' => 'Informe a hora INICIAL da tarde',
            'timeNightStart.required' => 'Informe a hora INICIAL da noite',
            'timeSpecialStart.required' => 'Informe a hora INICIAL do período especial',
            'timeMorningEnd.required' => 'Informe a hora FINAL da manhã',
            'timeAfternoonEnd.required' => 'Informe a hora FINAL da tarde',
            'timeNightEnd.required' => 'Informe a hora FINAL da noite',
            'timeSpecialEnd.required' => 'Informe a hora FINAL do período especial',
        ];
    }
}
