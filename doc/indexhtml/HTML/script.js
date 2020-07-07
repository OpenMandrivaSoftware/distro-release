
function StartPage(url) {
    this.location = url;
}

StartPage.prototype.run = function () {
    var product_id = '',
        lang       = '',
        args       = [];

    document.getElementsByTagName("body").item(0).setAttribute("class", "");

    if (null !== (product_id = this.getProductId())) {
        args.push('p=' + product_id);
    }

    if (null !== (lang = this.getLocale())) {
        args.push('l=' + lang);
    }

    if (args.length > 0) {
        this.location = [this.location, args.join('&')].join('?');
    }
    parent.location = this.location;

    return true;
};

StartPage.prototype.getLocale = function () {
    var ret = null;

    try {
        ret = parent.window.document.documentElement.attributes.getNamedItem('lang').value.trim();
    } catch (e) {}

    return ret;
};

StartPage.prototype.getProductId = function () {
    var ret = null,
        t = document.getElementsByTagName('meta');

    for (var i = 0; i < t.length; i += 1) {
        if (t.item(i).getAttribute('name') === 'product:id') {
            ret = t.item(i).getAttribute('content').trim();
            break;
        }
    }

    return ret;
};
