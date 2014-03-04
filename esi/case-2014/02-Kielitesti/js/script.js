$(function () {
  //var ylePath = 'http://yle.fi/embed/2014/02_kielitesti/';
  var ylePath = 'case-2014/02-Kielitesti/';

  var yleApp = {
    // Add thousand separators and convert dots to commas.
    formatNr: function(x) {
      x = x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
      x = x.replace('.', ',');
      return (x == '') ? 0 : x;
    },
    // Rounds numbers.
    roundNr: function(number, digits) {
      var multiple = Math.pow(10, digits);
      var rndedNum = Math.round(number * multiple) / multiple;
      return rndedNum;
    },
    // Handle responsive design.
    getScale: function() {
      var width = $('#esi-vis').width();
      // Full.
      if (width >= 578) {
        $('#esi-vis').addClass('wide');
        return true;
      }
      // Smaller.
      if (width < 578) {
        $('#esi-vis').removeClass('wide');
        return false;
      }
    },
    getData: function() {
      $.ajax({
        url: ylePath + 'data/questions.json',
        method: 'GET',
        dataType: 'json',
        success: function(data) {
          yleApp.printData(data);
        }
      });
    },
    printData: function(data) {
      var questions_cont = $('.questions', '#esi-vis').empty();
      $.each(data, function(question_key, question) {
        if (question_key < 1) {
          return;
        }
        var question_cont = $('<div class="question"></div>').appendTo(questions_cont);
        $('<h3>' + question.name + '</h3>').appendTo(question_cont);
        if (question.question) {
          $('<p>' + question.question + '</p>').appendTo(question_cont);
        }
        if (question.img) {
          $('<img src="' + ylePath + 'img/q_img/' + question.img + '" class="question_img" alt="" />').appendTo(question_cont)
        }
        $.each(question.answers, function(answer_key, answer) {
          var answer_cont = $('<div class="answer answer_' + question_key + '_' + answer_key + '"></div>').appendTo(question_cont);
          var label_cont = $('<label></label>').appendTo(answer_cont);
          $('<input type="radio" class="input required" name="q_' + question_key + '" id="q_' + question_key + '_' + answer_key + '" value="' + answer.is_true + '" /> <span class="label">' + answer.name + '</span>').appendTo(label_cont);
          var indicator_cont = $('<span class="indicator_container"></span>').appendTo(label_cont);
          if (answer.is_true === true) {
            answer_cont.addClass('corrent_answer');
            $('<span class="correct hidden"><img src="' + ylePath + '/img/green.png" alt="" class="indicator" /></span>').appendTo(indicator_cont);
          }
          else {
            $('<span class="incorrect hidden"><img src="' + ylePath + '/img/red.png" alt="" class="indicator" /></span>').appendTo(indicator_cont);
          }
        });
        if (question.answer != '') {
          $('<div class="desc hidden">' + question.answer + '</div>').appendTo(question_cont);
        }
        if (question.footer) {
          $(question.footer).appendTo(question_cont);
        }
      });
    },
    checkReady: function() {
      var all_answered = true;
      $.each($('.required', '#esi-vis'), function(key, answer) {
        if ($('input[name=' + answer.name + ']:checked', '#esi-vis').length === 0) {
          all_answered = false;
        }
      });
      return all_answered;
    },
    countCorrect: function() {
      var correct_count = 0;
      for (i = 1; i <= 11; i++) {
        var selected = $('input[name="q_' + i + '"]:checked', '#esi-vis');
        
        selected.parent('.answer').find('.incorrect').fadeIn(500);
        correct_count = (selected.val() === 'false') ? correct_count : correct_count + 1;
      }
      return correct_count;
    },
    printSomeLinks: function(correct_count) {
      var url = window.location.href;

      // Facebook share.
      var fbtitle = some_desc[correct_count];
      var fbtext = 'Kokeile miten itse pärjäät.';

      $('.facebook', '#esi-vis').attr({href: 'https://www.facebook.com/dialog/feed?app_id=147925155254978&display=popup&name=' + encodeURIComponent(fbtitle) + '&caption=' + fbtext + '&link=' + encodeURIComponent(url) + '&redirect_uri=' + url})

      //$('.facebook', '#esi-vis').attr({href: 'http://www.facebook.com/sharer.php?s=100&p[title]=' + encodeURI(fbtitle) + '&p[summary]=' + encodeURI(fbtext) + '&p[images][0]=' + encodeURI(fbimage) + '&p[url]=' + encodeURIComponent(url)});

      // Twitter share.
      var twtext = some_desc[correct_count] + ' Kokeile itse!';
      $('.twitter', '#esi-vis').attr({href: 'https://twitter.com/share?url=' + encodeURIComponent(url) + '&hashtags=kielitesti,yle&text=' + encodeURI(twtext)});
    },
    init: function() {
      yleApp.getScale();
      $(window).resize(function () {
        yleApp.getScale();
      });
      yleApp.getData();

      $('#esi-vis').on('change', '.age_container input', function(e) {
        $('input[name="entry.1083770188"]', '#esi-vis').val($(this).val());
        if (yleApp.checkReady()) {
          var answer_input = [];
          for (i = 1; i <= 12; i++) {
            var selected = $('input[name="q_' + i + '"]:checked', '#esi-vis');
            if (selected.length != 0) {
              answer_input.push(selected.attr('id'));
            }
          }
          $('input[name="entry.1421273224"]', '#esi-vis').val(answer_input.join(','));
          $('.esi_form', '#esi-vis')[0].submit();

          $('.result_container .result', '#esi-vis').html('<h3>' + answers_desc[yleApp.countCorrect()] + '</h3>');
          yleApp.printSomeLinks(yleApp.countCorrect());
          $('.result_container', '#esi-vis').show();
          $('input[name="age"]', '#esi-vis').attr('disabled', 'disabled');
        }
      });
      $('#esi-vis').on('change', '.question input', function(e) {
        $('input[name="' + $(this).attr('name') + '"]', '#esi-vis').attr('disabled', 'disabled');
        $(this).parent('label').find('.indicator_container span').show();
        $('input[name="' + $(this).attr('name') + '"]', '#esi-vis').parent('label').css('color', '#999');
        $(this).parent('label').css('color', '#000');
        $(this).parent('label').css('font-weight', 'bold');
        $(this).parent('label').parent('.answer').parent('.question').find('label').addClass('disabled')
        $(this).parent('label').parent('.answer').parent('.question').find('.desc').slideDown();
        if (yleApp.checkReady()) {
          var answer_input = [];
          for (i = 1; i < 15; i++) {
            var selected = $('input[name="q_' + i + '"]:checked', '#esi-vis');
            if (selected.length != 0) {
              answer_input.push(selected.attr('id'));
            }
          }
          $('input[name="entry.1421273224"]', '#esi-vis').val(answer_input.join(','));
          $('.esi_form', '#esi-vis')[0].submit();

          $('.result_container .result', '#esi-vis').html('<h3>' + answers_desc[yleApp.countCorrect()] + '</h3>');
          yleApp.printSomeLinks(yleApp.countCorrect());
          $('.result_container', '#esi-vis').show();
        }
      });
    }
  }
  yleApp.init();
});