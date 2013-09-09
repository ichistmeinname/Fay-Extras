$(document).ready( function() {
    $(".loading-img").css({"display": "none"});
    addLoadingAnimation(1,0);
});


function addLoadingAnimation(index,count) {
    if (count == 50) {
        return;
    } else if (index == 3) {
        setActive();
        setTimeout( function() {
            addLoadingAnimation(0,count+1);
        }, 500);
    } else if (index == 0) {
        $(".loading-img").hide();
        setTimeout( function() {
            addLoadingAnimation(1,count+1);
        }, 500);
    } else {
        setActive();
        setTimeout( function() {
            addLoadingAnimation(index+1,count+1);
        }, 500);
    }
    function setActive() {
        $("#loading"+index.toString()).css({"display": "block"});
    }
}

$(window).load( function() {
    // hide loading screen and show content
    var container = $("#container");
    $("#loading").fadeOut(1000);
    container.fadeIn(2000);
    // activate home as current navigation item
    $("#nav-item1").addClass("active-nav");
    $("#back-button").click( function () { deactivateProductFrame(); } );
    var navigationElements = $(".nav-item");
    $(".movable").each( function(index) { addStartValues(index, $(this)); } );
    addXValue(-1.4,$(".layer1"));
    addXValue(-1,$(".layer2"));
    addXValue(-0.6,$(".layer3"));
    addSlideshow(6000,$("#slideshow"));
    $(".kreis").each( function() { addProductHover($(this)); } );
    $(".product").each( function() { addProductNavigation($(this)); } );
    navigationElements.each( function(index) { addScrollNavigation(index,$(this)); } );
    deactivateProductFrame();
});

function addScrollNavigation(index, element) {
    $(element).click( function() {
        var content = $("#content");
        var currentActive = $(".active-nav");
        currentActive.removeClass("active-nav");
        $(element).addClass("active-nav");
        var newNumber = parseInt($(element).data("navnumber"));
        var currentNumber = parseInt(currentActive.data("navnumber"));
        var moveValue = (index * (-100)) + "%";
        var duration = Math.abs((currentNumber - newNumber) * 1000);
        content.animate({'left': moveValue}, duration);
        parallaxBubbles(index, duration);
        var currentId = currentActive.attr("id");
        var newId = $(element).attr("id");
        if (currentId == "nav-item3" && currentId == newId) {
            deactivateProductFrame();
        } else if (currentId == "nav-item3") {
            setTimeout( function () {
                deactivateProductFrame();
                $(".active-product").hide("Instantly").removeClass(".active-product");
            }, 1000);
        } else if (currentId == "nav-item4") {
            // reset contact site
            $(".error").hide("Slow");
            $("#message").hide("Slow");
            $("#contact-form").show("Slow");
            $("#mail-form").each(function() {
                this.reset();
            });
        }
    });
}

function parallaxBubbles(index, duration) {
    $(".movable").each( function(i) { addParallaxEffect(i,$(this)); } );

    function addParallaxEffect(i,element) {
        var xPos = parseInt($(element).data("x"));
        var startX = parseInt($(element).data("startx"));
        var leftValue = xPos * index + startX;
        var currentLeft = parseInt($(element).css("left"));
        var val1 = leftValue;
        var val2 = leftValue;
        if (currentLeft < leftValue) {
            val1 += 50;
        } else if (currentLeft > leftValue) {
            val2 += 50;
        }
        var duration2 = duration * 2;
        $(element).animate({'left': val1}, {'duration': duration2 * 0.7, 'easing': 'swing'})
            .animate({'left': val2}, {'duration': duration2 * 0.3, 'easing': 'swing'});
    }
}

function addProductNavigation(element) {
    $(element).click( function() {
        $(".active-product").removeClass("active-product");
        var productId = $(element).data("product");
        $(productId).addClass("active-product");

        var height = $("#container").height();
        $("#products").css({"height": height * 2/3});
        $("#back-button").css({"top": height+5})
            .css({"display": "block"})
            .animate({'top': -50}, 500);
        $("#product-frame").css({"height": height / 2})
            .css({"marginTop": height+5})
            .css({"scrollTop": 0})
            .css({"display": "block"})
            .animate({'margin-top': 0}, 500);
        $("#product-selection").animate({'top': -400}, 500);

    });

}

function addProductHover(element) {
    $(element).hover(function() { enter(); }, function() { leave(); } );
    $(element).css('-webkit-transform','scale(0.85,0.85)');
    $(element).css('-moz-transform','scale(0.85,0.85)');
    $(element).css('-o-transform','scale(0.85,0.85)');
    $(element).css('-ms-transform','scale(0.85,0.85)');
    $(element).css('transform','scale(0.85,0.85)');
    
    var productText = $(element).data("text");
    var dummyId = $(element).data("dummy");
    var dummyObj = $(dummyId);
    var productId = $(element).data("product");    

    function enter() {
        $(productId).animate(
             {'borderSpacing':100}
            ,{'step': function(now,fx) {
                $(element).css('-webkit-transform'
                           ,'scale('+(now/100)+','+(now/100)+')');
                $(element).css('-moz-transform'
                           ,'scale('+(now/100)+','+(now/100)+')');
                $(element).css('-o-transform'
                           ,'scale('+(now/100)+','+(now/100)+')');
                $(element).css('-ms-transform'
                           ,'scale('+(now/100)+','+(now/100)+')');
                $(element).css('transform'
                           ,'scale('+(now/100)+','+(now/100)+')');
            }, duration:'slow'}, 'linear');
        $(productText).css("color", "#253d6c");
        dummyObj.fadeOut(500);
    }

    function leave() {
        $(productId).removeClass("product-hover")
        $(productId).animate(
             {'borderSpacing':85}
            ,{'step': function(now,fx) {
                $(element).css('-webkit-transform'
                           ,'scale('+(now/100)+','+(now/100)+')');
                $(element).css('-moz-transform'
                           ,'scale('+(now/100)+','+(now/100)+')');
                $(element).css('-o-transform'
                           ,'scale('+(now/100)+','+(now/100)+')');
                $(element).css('-ms-transform'
                           ,'scale('+(now/100)+','+(now/100)+')');
                $(element).css('transform'
                           ,'scale('+(now/100)+','+(now/100)+')');
            },duration:'slow'},'linear');
        $(productText).css({"color": "#323232"});
        dummyObj.fadeIn(500);
    }
}

function addSlideshow(duration,object) {
    var slideshowCount = parseInt(object.data("slidecount"));
    var startObject = $(".first-slide");
    setTimeout( function(index) {
        return function() {
            nextImage(index,startObject);
        };
    }(1), duration);

    function nextImage(i,obj) {
        if (i < slideshowCount) {
            var next = obj.next();
            triggerAnimation(obj,next);
            setTimeout( function() {
                nextImage(i+1, next);
            }, duration);
        } else {
            triggerAnimation(obj,startObject);
            setTimeout( function() {
                nextImage(1,startObject);
            }, duration);
        }
    }

    function triggerAnimation(obj, nextObj) {
        obj.fadeOut(1000);
        nextObj.fadeIn(2000);
    }
}

function addXValue(factor,obj) {
    var width = $("body").width();
    obj.data("x",width * factor);
}

function deactivateProductFrame() {
    $("#product-selection").animate({'top': 0}, 500);
    var height = $("#container").height();
    $("#product-frame").animate({'margin-top': height}, 500);
    $("#back-button").animate({'top': height}, 500);
}

function addStartValues(index,element) {
    var startX = $(element).css("left");
    var startY = $(element).css("top");
    $(element).data("startx",startX);
    $(element).data("starty",startY);
}
