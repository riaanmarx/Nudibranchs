$(function () {
    $.ajaxSetup({
        // Disable caching of AJAX responses
        cache: false
    });

    // inject header and footer
    $("#pageheaderdiv").load("header.html", function () { setTimeout(setcurrentmenu, 1); });
    $("#pagefooterdiv").load("footer.html", function () { setTimeout(setcurrentmenu, 1); });   
});

function setcurrentmenu()
{
    pagepathelements = window.location.pathname.split('/');
    pagename = pagepathelements[pagepathelements.length-1].split('.')[0];

    $('.'+pagename+'menu').addClass('selectedmenu');
    
}

function InjectGlossaryHyperlinks(callbackfn)
{
    $.ajax({
        url: 'terminology.html',
        success: function (data, status, xhr) {
            $HTML = $.parseHTML(xhr.responseText, true);
            $Table = $("#Termstable", $HTML);
            $('a[name]', $Table).each(function (index, element) {

                term = element.name;

                var wordss;
                if (element.attributes['data-aka'] == null) 
                    wordss = term.split(',');
                else 
                    wordss = element.attributes['data-aka'].value.split(',');
                    
                for (var j = 0; j < wordss.length; j++) {
                    word = wordss[j];
                    var re = new RegExp("\\b" + word + "\\b", "g");
                    var hl = "<a class='hotword' href='terminology.html#" + term + "' title='" + $("a[name=\'" + term + "\']",$Table).text() + "'>" + word + "</a>"

                    $("#pagebodydiv").html(function () {
                        return $("#pagebodydiv").html().replace(re, hl);
                    });
                }
                
            });
            callbackfn();
        }
    });

    

}