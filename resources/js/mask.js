const phoneMask = (value) => {
    if (!value) return "";
    value = value.replace(/\D/g, "");
    value = value.replace(/(\d{2})(\d)/, "$1$2");
    value = value.replace(/(\d)(\d{4})$/, "$1$2");
    return value;
};

const docsMask = (value) => {
    if (!value) return "";
    if (value.length <= 14) {
        value = value.replace(/\D/g, "");
        value = value.replace(/(\d{3})(\d)/, "$1.$2");
        value = value.replace(/(\d{3})(\d)/, "$1.$2");
        value = value.replace(/(\d{3})(\d{1,2})$/, "$1-$2");
    } else {
        value = value.replace(/\D/g, "");
        value = value.replace(/^(\d{2})(\d)/, "$1.$2");
        value = value.replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3");
        value = value.replace(/\.(\d{3})(\d)/, ".$1/$2");
        value = value.replace(/(\d{4})(\d)/, "$1-$2");
    }
    return value;
};

const currencyMask = (value, locales = "pt-BR") => {
    if (!value) return "";
    value = value.replace(".", "").replace(",", "").replace(/\D/g, "");
    let options = {minimumFractionDigits: 2};
    value = new Intl.NumberFormat(locales, options).format(
        parseFloat(value) / 100
    );

    return value;
};

export {phoneMask, docsMask, currencyMask};
