function selectEditSlot(el) {
    if (el.classList.contains('disabled')) return;
    var parent = el.parentNode;
    var siblings = parent.querySelectorAll('.slot-btn');
    siblings.forEach(function (b) { b.classList.remove('active'); });
    el.classList.add('active');
    var hidden = document.getElementById('<%= hfEditSelectedTime.ClientID %>');
    if (hidden) hidden.value = el.getAttribute('data-time');
}

(function () {
    var dt = document.getElementById('<%= txtEditDate.ClientID %>');
    if (dt) {
        var tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        var mm = String(tomorrow.getMonth() + 1).padStart(2, '0');
        var dd = String(tomorrow.getDate()).padStart(2, '0');
        dt.min = tomorrow.getFullYear() + '-' + mm + '-' + dd;
    }
})();