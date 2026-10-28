(function () {
    var prm = Sys.WebForms.PageRequestManager.getInstance();

    /* After every async postback: remove orphaned Bootstrap backdrops
       and restore body scroll if no modal is actually open. */
    prm.add_endRequest(function () {
        var openModal = document.querySelector('.modal.show');

        document.querySelectorAll('.modal-backdrop').forEach(function (el) {
            if (!openModal) el.parentNode.removeChild(el);
        });

        if (!openModal) {
            document.body.classList.remove('modal-open');
            document.body.style.removeProperty('overflow');
            document.body.style.removeProperty('padding-right');
        }
    });
}());