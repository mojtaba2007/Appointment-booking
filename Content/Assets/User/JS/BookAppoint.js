var services = {};

var ddlServiceId = '<%= ddlService.ClientID %>';
var hfDateId = '<%= hfSelectedDate.ClientID %>';
var hfTimeId = '<%= hfSelectedTime.ClientID %>';
var btnLoadId = '<%= btnLoadSlots.ClientID %>';

$(function () {
    $('#txtDateDisplay').persianDatepicker({
        format: 'YYYY/MM/DD',
        autoClose: true,
        initialValue: false,
        minDate: new persianDate().add('days', 1),
        onSelect: function (unixDate) {
            var pd = new persianDate(unixDate);
            var gd = pd.toCalendar('gregorian');
            var y = gd.year();
            var m = String(gd.month()).padStart(2, '0');
            var d = String(gd.date()).padStart(2, '0');
            document.getElementById(hfDateId).value = y + '-' + m + '-' + d;
            document.getElementById('dateError').style.display = 'none';
            tryLoadSlots();
            updateSteps();
        }
    });

    document.getElementById(ddlServiceId).addEventListener('change', function () {
        var val = this.value;
        if (val && services[val]) {
            document.getElementById('serviceInfo').style.display = 'block';
            document.getElementById('svcDuration').textContent = services[val].duration;
            document.getElementById('svcPrice').textContent =
                Number(services[val].price).toLocaleString('fa');
        } else {
            document.getElementById('serviceInfo').style.display = 'none';
        }
        tryLoadSlots();
    });
});

function tryLoadSlots() {
    var svcVal = document.getElementById(ddlServiceId).value;
    var dateVal = document.getElementById(hfDateId).value;
    if (!svcVal || !dateVal) return;
    document.getElementById(btnLoadId).click();
}

function selectSlot(btn) {
    document.querySelectorAll('.slot-btn.selected')
        .forEach(function (b) { b.classList.remove('selected'); });
    btn.classList.add('selected');
    document.getElementById(hfTimeId).value = btn.getAttribute('data-time');
    document.getElementById('timeError').style.display = 'none';
    updateSummary();
    updateSteps();
}

function updateSummary() {
    var ddl = document.getElementById(ddlServiceId);
    var svcVal = ddl.value;
    var fullText = ddl.options[ddl.selectedIndex].text;
    var svcText = fullText.replace(/\s*\(.*?\)\s*$/, '');
    var dateTxt = document.getElementById('txtDateDisplay').value;
    var time = document.getElementById(hfTimeId).value;

    if (!svcVal || !dateTxt || !time) {
        document.getElementById('summaryBox').style.display = 'none';
        return;
    }

    document.getElementById('summaryBox').style.display = 'block';
    document.getElementById('sumService').textContent = svcText;
    document.getElementById('sumDate').textContent = dateTxt;
    document.getElementById('sumTime').textContent = time;
    document.getElementById('sumDuration').textContent =
        (services[svcVal] ? services[svcVal].duration : '') + ' دقیقه';
    document.getElementById('sumPrice').textContent =
        (services[svcVal] ? Number(services[svcVal].price).toLocaleString('fa') : '') + ' تومان';
}

function validateForm() {
    var ok = true;
    if (!document.getElementById(hfDateId).value) {
        document.getElementById('dateError').style.display = 'block';
        ok = false;
    }
    if (!document.getElementById(hfTimeId).value) {
        document.getElementById('timeError').style.display = 'block';
        ok = false;
    }
    return ok;
}

var prm = Sys.WebForms.PageRequestManager.getInstance();
prm.add_endRequest(function () {
    var saved = document.getElementById(hfTimeId).value;
    if (saved) {
        document.querySelectorAll('.slot-btn').forEach(function (b) {
            if (b.getAttribute('data-time') === saved)
                b.classList.add('selected');
        });
    }
});

function updateSteps() {
    var svcVal = document.getElementById(ddlServiceId).value;
    var dateVal = document.getElementById(hfDateId).value;
    var timeVal = document.getElementById(hfTimeId).value;

    var divservice = document.getElementById("service");
    var divdate = document.getElementById("date");
    var divhour = document.getElementById("hour");
    var divsubmit = document.getElementById("submit");


    [divservice, divdate, divhour, divsubmit].forEach(function (d) {
        d.classList.remove("active", "done");
    });

    if (!svcVal) {
        divservice.classList.add("active");
        return;
    }
    divservice.classList.add("done");

    if (!dateVal) {
        divdate.classList.add("active");
        return;
    }
    divdate.classList.add("done");

    if (!timeVal) {
        divhour.classList.add("active");
        return;
    }
    divhour.classList.add("done");

    divsubmit.classList.add("active");
}


document.getElementById(ddlServiceId).addEventListener('change', updateSteps);