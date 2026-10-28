var MOBILE_BP = 992;

/* ── Toggle sidebar ── */
function toggleSidebar() {
    if (window.innerWidth < MOBILE_BP) {
        openMobileSidebar();
    } else {
        var collapsed = document.body.classList.toggle('sb-collapsed');
        localStorage.setItem('adminSbCollapsed', collapsed ? '1' : '0');
    }
}

function openMobileSidebar() {
    document.getElementById('adminSidebar').classList.add('mobile-open');
    document.getElementById('sbOverlay').classList.add('active');
}

function closeMobileSidebar() {
    document.getElementById('adminSidebar').classList.remove('mobile-open');
    document.getElementById('sbOverlay').classList.remove('active');
}

/* ── Restore collapsed on desktop ── */
(function () {
    if (window.innerWidth >= MOBILE_BP &&
        localStorage.getItem('adminSbCollapsed') === '1') {
        document.body.classList.add('sb-collapsed');
    }
})();

/* ── Active nav item ── */
(function () {
    var path = window.location.pathname.toLowerCase();
    var map = {
        'adminhome': 'navHome',
        'manageappointments': 'navAppt',
        'manageservices': 'navSvc',
        'manageusers': 'navUsr'
    };
    for (var key in map) {
        if (path.indexOf(key) > -1) {
            var el = document.getElementById(map[key]);
            if (el) el.classList.add('active');
            break;
        }
    }
})();