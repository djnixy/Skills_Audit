function getFlashMovieObject(movieName)
{
  if (window.document[movieName]) 
  {
    return window.document[movieName];
  }
  if (navigator.appName.indexOf("Microsoft Internet")==-1)
  {
    if (document.embeds && document.embeds[movieName])
      return document.embeds[movieName]; 
  }
  else // if (navigator.appName.indexOf("Microsoft Internet")!=-1)
  {
    return document.getElementById(movieName);
  }
}

function PlayFlashMovie()
{
	var flashMovie=getFlashMovieObject("simplemovie");
	flashMovie.Play();
}


function getoj(id) {

return document.getElementById(id);

}

//function to show a invisibe div to visible after a aset amount of time
function timeout()
{
	setTimeout("toggleLayer2('commentForm')", 90000 );
			   
}

//Creates a apopup window for the flas calculator
function popup(){
newwindow = window.open("../calculator", width ="150" , height ="100" );
if (window.focus) {newwindow.focus()}  
return false;
}

//allows for a alayer to be toggles on and off
function toggleLayer( whichLayer )
{
  var elem, vis;
  if( document.getElementById ) // this is the way the standards work
    elem = document.getElementById( whichLayer );
  else if( document.all ) // this is the way old msie versions work
      elem = document.all[whichLayer];
  else if( document.layers ) // this is the way nn4 works
    elem = document.layers[whichLayer];
  vis = elem.style;
  // if the style.display value is blank we try to figure it out here
  if(vis.display==''&&elem.offsetWidth!=undefined&&elem.offsetHeight!=undefined)
	vis.display = (elem.offsetWidth!=0&&elem.offsetHeight!=0)?'block':'none';
  vis.display = (vis.display==''||vis.display=='block')?'none':'block';
}

//toggles a layer on but not off
function toggleLayer2( whichLayer )
{
  var elem, vis;
  if( document.getElementById ) // this is the way the standards work
    elem = document.getElementById( whichLayer );
  else if( document.all ) // this is the way old msie versions work
      elem = document.all[whichLayer];
  else if( document.layers ) // this is the way nn4 works
    elem = document.layers[whichLayer];
  vis = elem.style;
  // if the style.display value is blank we try to figure it out here
  if(vis.display==''&&elem.offsetWidth!=undefined&&elem.offsetHeight!=undefined)
	vis.display = (elem.offsetWidth!=0&&elem.offsetHeight!=0)?'none':'block';
  vis.display = (vis.display==''||vis.display=='block')?'block':'none';
}
 
//Writes the serialised value of the order of a a drag and drop list and puts it into a hidden field
 function writedd(howmany, testelement)
 {
     var notify = document.getElementById("result_answer");
     notify.value = Sortable.serialize(testelement);
     var testtext = notify.value;
     
     for(var i = 0 ; i <= (howmany) ; i++)
      {
        testtext = testtext.replace(testelement +"[]=","");
        testtext = testtext.replace("&",",");
      }

     notify.value = testtext;
     
 }

 //writes the exam question order out for saving question orders in add_questions
 function examdd(howmany, testelement)
 {
     var notify = document.getElementById("result_answer");
     notify.value = Sortable.serialize(testelement);
     var testtext = notify.value;
     
     for(var i = 0 ; i <= (howmany) ; i++)
      {
        testtext = testtext.replace(testelement+"[]=0&","");
        testtext = testtext.replace(testelement +"[]=","");
        testtext = testtext.replace("&",",");
    
      }
      
     if (testtext == ""){
         alert("cannot create a test with no questions")
         return false;
     }
     else{

     notify.value = testtext;
     }
 }
 
 //function that hides the njs div that contains the degradated html for a order question
 function showdd()
 {
     document.getElementById('javascript').style.display = 'block';
     document.getElementById('njs').style.display = 'none';

 }
 
 
 // writing 
 function writemd(howmany)
 {
     var notify = document.getElementById("result_answer");
     
     var testtext = Sortable.serialize("result") +','+ Sortable.serialize("result2") ;
     
     for(var i = 0 ; i <= (howmany) ; i++)
      {
        testtext = testtext.replace("result[]=","");
        testtext = testtext.replace("result2[]=","");
        testtext = testtext.replace("&",",");
    
      }

     notify.value = testtext.replace("&result[]=",",");
     
 }
 
 //Variables for the spelling functions
   var spellOrder = new Array();
   var divcount;
   var count;
   var last;
   
 //javascript for loading a spelling question
 function spellLoad()
 {
    questcount = document.getElementById("questionAmount");

    last = new Array(questcount.value);
    
      for(var i = 0 ; i <(questcount.value) ; i++)
       { 
          last[i]="0";
          spellOrder[i]="0";
       } 
     // for previous question stuff
     var old_answer = document.getElementById("back_question").value;
     var old_answer_array = new Array();
     old_answer_array = old_answer.split(',');
    // alert(old_answer_array);
     for (var x=0; x < old_answer_array.length; x++)
         {
         //    alert(old_answer_array[x]);
             document.getElementById(old_answer_array[x]).className = "highlight";
             last[x] = old_answer_array[x];
             spellOrder[x]=old_answer_array[x];
         }
         // end previous question code
   }

  
 //changes the text class for highlighting in a spelling test
   function spelling(id, selection, highlight)
 
 {
     //alert(highlight);
    id2 = id-1;
    //alert(id);
     var notify = document.getElementById("result_answer");  
    // document.getElementById('spell'+last[id]).style.background = '#e3ede5';
     if(last[id2] != 0){
         //alert("test");
         //document.getElementById('spell'+last[id]).className = "nhighlight";
         document.getElementById(last[id2]).className = "nhighlight";
     }
     
     else if (last[id2] ==0 & id ==0){
         //alert("test2");
         //document.getElementById('spell'+last[id]).className = "nhighlight";
         document.getElementById(last[id2]).className = "nhighlight";
         //alert("test3");
     }
     else
     {
         //alert("test3");
     }
     
       //alert("test4");
     //document.getElementById('spell'+last[id]).className = "nhighlight";
     spellOrder[id2]= selection;
     last[id2] = highlight;
     
     //alert("test5");
    // document.getElementById('spell'+highlight).style.background = '#99ffff';
    //document.getElementById('spell'+highlight).className = "highlight";
    document.getElementById(highlight).className = "highlight";
       notify.value = spellOrder;
 }
 
   //spelling submit code, checks to make sure every answer is selected
    function spellmit()
       {
       var questcount = document.getElementById("questionAmount");
       length = questcount.value;
       
      var count=0;
      if (length != (spellOrder.length))
         {
            alert("You have not answered every question.")
             return false;
             count = 1;
         }
      else if(questcount.value == (spellOrder.length)) 
      {
          for (var e =0; e<(((spellOrder.length))); e++)
          {
           
            if( spellOrder[e] == "0")
            {
              count = count+1;
            }
          }
     } 
     if (count ==0)
         {
             return true;
         }
         else
             {
                 alert("You have not answered every question.");
                 return false;
             }
   }
   
    function autocompleteoff(){
        if (document.getElementsByTagName) { 
          var inputElements = document.getElementsByTagName("input"); 
          for (i=0; inputElements[i]; i++) { 
          if (inputElements[i].className && (inputElements[i].className.indexOf("textfield") != -1)) { 
          inputElements[i].setAttribute("autocomplete","off"); 
        }//if current input element has the disableAutoComplete class set. 
      }//loop thru input elements 
    }//basic DOM-happiness-check 

        
    }
    
   function setfocus(a_field_id) {
        $(a_field_id).focus()
    }
    
   //Allows a radio button choice to be selected by clicking the associated text
   function rbtclick(choice){
       document.getElementById('result_answer_'+choice).checked = true;
   }
   
   //shows and hides the question info part of question boxes in add_questions
   function teachtest(div){
       //alert("test");
       var e = div;
       
       //document.getElementById("questadd"+e).style.display = 'block';
       if(document.getElementById("showhide"+e).value=="+"){
          document.getElementById("box"+e).style.height = '200px'; 
          document.getElementById("showhide"+e).value="-"
       }
       else{
           document.getElementById("box"+e).style.height = '50px';
           document.getElementById("showhide"+e).value="+"
       }
       toggleLayer("questadd"+e);
       
   }
   
   var min=8;
var max=18;

function increaseFontSize() {
   var p = document.getElementsByTagName('p');
   for(i=0;i<p.length;i++) {
      if(p[i].style.fontSize) {
         var s = parseInt(p[i].style.fontSize.replace("px",""));
      } else {
          s = 12;
      }
      if(s!=max) {
         s += 1;
      }
      p[i].style.fontSize = s+"px"
   }
   
   var li = document.getElementsByTagName('li');
   for(i=0;i<li.length;i++) {
      if(li[i].style.fontSize) {
          s = parseInt(li[i].style.fontSize.replace("px",""));
      } else {
          s = 12;
      }
      if(s!=max) {
         s += 1;
      }
      li[i].style.fontSize = s+"px"
   }
}

function sorttextanswers() {
    var test = document.getElementById('back_question');
    var test2 = document.getElementById('result_0_answer').value;
    test.value = test2;
    var result_array=test2.split(",");
    
    //alert(result_array);

    for (i=0;i<result_array.length; i++)
        {
          //  alert("test"+i);
            document.getElementById('result_'+i+'_answer').value = result_array[i];
        }
    
}

function decreaseFontSize() {
   var p = document.getElementsByTagName('p');
   for(i=0;i<p.length;i++) {
      if(p[i].style.fontSize) {
         var s = parseInt(p[i].style.fontSize.replace("px",""));
      } else {
          s = 12;
      }
      if(s!=min) {
         s -= 1;
      }
      p[i].style.fontSize = s+"px"
   } 

   var li = document.getElementsByTagName('li');
   for(i=0;i<li.length;i++) {
      if(li[i].style.fontSize) {
          s = parseInt(li[i].style.fontSize.replace("px",""));
      } else {
          s = 12;
      }
      if(s!=min) {
         s -= 1;
      }
      li[i].style.fontSize = s+"px"
   }
}

//loads the sortable order if a result has been saved
function sortableload(){
    
    var old_answer = document.getElementById("back_question").value;
     var old_answer_array = new Array();
     old_answer_array = old_answer.split(',');
   if (old_answer != "" && old_answer != "0" )
  {            
    Sortable.setSequence('result',old_answer_array);
  }
}
    
    function exam_warning(){
    var message = "One or more students are already assigned to the exam you are editing.  If you edit this test a new version will be created and the old test will be depreciated.";
    
    var return_value = confirm(message);
    
    if (return_value == true)
        {
            return true;
            
        }
    else
        {
            return false
        }
}

//Shows a warning for tests with assigned students and strips the sortable order
function examdd_warn(howmany, testelement)
 {
     var notify = document.getElementById("result_answer");
     notify.value = Sortable.serialize(testelement);
     var testtext = notify.value;
     
     for(var i = 0 ; i <= (howmany) ; i++)
      {
        testtext = testtext.replace(testelement+"[]=0&","");
        testtext = testtext.replace(testelement +"[]=","");
        testtext = testtext.replace("&",",");
    
      }
      
     if (testtext == ""){
         alert("cannot create a test with no questions")
         return false;
     }
     else{
        // alert("test");
     var message = "One or more students are already assigned to the exam you are editing.  If you edit this test a new version will be created and the old test will be depreciated.";
    
    var return_value = confirm(message);
    
    if (return_value == true)
        {
            //alert("test2");
            notify.value = testtext; 
            return true;
              
        }
    else
        {
           // alert("test3");
            return false
        }
     }
 }
