import moment from "moment";

function validateDate(date) {
    if (date === '' || !date) return false
    return date ? moment(date).isSame(moment(), 'day') || moment(date).isAfter(moment(), 'day') : false
}

export {validateDate}
