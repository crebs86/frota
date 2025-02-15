import has from "@/arrayHelpers";

export default function validateCUR(value, ignore = []) {
    let errors = '{"errors":{';
    let partial = "";

    if (!value.data && !has(ignore, ['data'])) {
        partial += '"data": ["Informa uma data."],';
    }

    if (!value.hora && !has(ignore, ['hora'])) {
        partial += '"hora": ["Informe um horário."],';
    }

    if (!value.quantidade && !has(ignore, ['quantidade'])) {
        partial += '"quantidade": ["Informe a quatidade."],';
    }

    if (!value.valor && !has(ignore, ['valor'])) {
        partial += '"valor": ["Informe o valor do abastecimento."],';
    }

    if (!value.local && !has(ignore, ['local'])) {
        partial += '"local": ["Informe o local do abastecimento."],';
    }

    if (!value.observacao && !has(ignore, ['observacao'])) {
        partial += '"observacao": ["Informe uma observacao."],';
    }

    if (!value.km && !has(ignore, ['km'])) {
        partial += '"km": ["Informe a quilometragem no momento do abastecimento."],';
    }

    if (partial.length === 0) {
        errors += '"_run":true}}';
    } else {
        errors += "" + partial + ' "_run":false}}';
    }

    return JSON.parse(errors).errors;
}
