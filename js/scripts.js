// Toggle @classname@ on or off for each element in @elems@.
function toggle(classname, elems) {
    for(var i in elems) {
        document.getElementById(elems[i]).classList.toggle(classname);
    }
}

function toggleSidebar(sidebar) {
    document.getElementById(sidebar).classList.toggle(sidebar);
}
