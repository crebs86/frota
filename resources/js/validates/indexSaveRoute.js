export default function validate(value) {
  let errors = '{"errors":{';
  let partial = "";

  if (!value.driver?.id) {
    partial += '"driver": ["Erro ao carregar motorista."],';
  }

  if (!value.date) {
    partial += '"date": ["Informa uma data."],';
  }

  if (!value.time) {
    partial += '"time": ["Informe um horário."],';
  }

  if (!value.branch?.id) {
    partial += '"branch": ["Informe uma unidade destino."],';
  }

  if (value.branch?.id === 1) {
    if (!value.local) {
      partial += '"local": ["Informe um local destino avulso."],';
    }
  }

  if (partial.length === 0) {
    errors += '"_run":true}}';
  } else {
    errors += "" + partial + ' "_run":false}}';
  }

  return JSON.parse(errors).errors;
}
