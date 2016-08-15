var NAME = ['O','L','I','v','I','A'];
var LZH_RADIUS = 5;
var LZH_WINDOW_WIDTH =1000;
var LZH_WINDOW_HEIGHT=5000;
var LZH_MARGIN_LEFT = 10;
var LZH_MARGIN_TOP = 0;
const lzh_colors = ["#33B5E5","#0099CC","#AA66CC","#9933CC","#99CC00","#669900","#FFBB33","#FF8800","#FF4444","#CC0000"];
//const lzh_colors = ["#002222","#220000"];
$(function(){
	LZH_WINDOW_WIDTH=document.body.clientWidth
	LZH_WINDOW_HEIGHT=document.body.clientHeight/4
	var lzh_canvas = document.getElementById('w_canvas');
    var lzh_context = lzh_canvas.getContext("2d");
    lzh_canvas.width = LZH_WINDOW_WIDTH;
    lzh_canvas.height = LZH_WINDOW_HEIGHT;
     var num=0
     setInterval(
         function(){
         	if(num>NAME.length-1){
         		lzh_context.clearRect(0,0,LZH_WINDOW_WIDTH, LZH_WINDOW_HEIGHT);
         		my_render(lzh_context)
         		num=0
         	}else{
         		if (num==0){
         			lzh_context.clearRect(0,0,LZH_WINDOW_WIDTH, LZH_WINDOW_HEIGHT);
         		}

         	render_char(LZH_MARGIN_LEFT+ num*8*(RADIUS+1),LZH_MARGIN_TOP,lzh_char[NAME[num]],lzh_context)
         	num++;
         	}
            // my_render(lzh_context)
         }
         ,
         1000
     );
})

function my_render(cxt){
	cxt.clearRect(0,0,LZH_WINDOW_WIDTH, LZH_WINDOW_HEIGHT);
	for (var i = 0 ; i < NAME.length ; i++) {
		render_char(LZH_MARGIN_LEFT+ i*8*(RADIUS+1),LZH_MARGIN_TOP,lzh_char[NAME[i]],cxt)
	};
}
function render_char(x , y , arr , cxt){
	for( var i = 0 ; i < arr.length ; i ++ ){
        for(var j = 0 ; j < arr[i].length ; j ++ ){
            if( arr[i][j] == 1 ){
                cxt.beginPath();
                cxt.arc( x+j*2*(LZH_RADIUS+1)+(LZH_RADIUS+1) , y+i*2*(LZH_RADIUS+1)+(LZH_RADIUS+1) , LZH_RADIUS , 0 , 2*Math.PI )
                cxt.closePath()
                cxt.fillStyle = lzh_colors[GetRandomNum(1,10)]//"rgb(0,102,153)";
                cxt.fill()
            }
        }
	}

}
function GetRandomNum(Min,Max)
{   
var Range = Max - Min;   
var Rand = Math.random();   
return(Min + Math.round(Rand * Range));   
}   
function sleep(numberMillis) { 
var now = new Date(); 
var exitTime = now.getTime() + numberMillis; 
while (true) { 
now = new Date(); 
if (now.getTime() > exitTime) 
return; 
} 
}