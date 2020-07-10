
function enter(c, dx, dy, sx, sy) {
    c.save();
    c.translate(dx,dy);
    c.scale(sx,sy);
}

function leave(c, fs, ss) {
    c.restore();
    c.fillStyle = fs;
    c.strokeStyle = ss;
    c.fill();
    c.stroke();
}


function Circulo(c) {
    c.beginPath();
        c.ellipse( 0,0, 1,1, 0, 0,2*Math.PI);	//criar circulo
    c.closePath();
}

function retangulo(c){
	c.beginPath();
		c.rect(-1,-1,1,1)						//criar retangulo
	c.closePath();

}



function triangulo(c){
	c.beginPath();
        c.moveTo(0,-1);
        c.lineTo(-1,1);							//criar triangulo
        c.lineTo(1,1);
        c.lineTo(0,-1);
    c.closePath();
}


function Ponte(c) {
	c.beginPath();
		c.moveTo(0.859,0.438);
		c.quadraticCurveTo(-0.05,0.27,-0.6,-0.508);
		c.quadraticCurveTo(0.05,0.35,0.72,0.491); 
		c.quadraticCurveTo(0.6,0.44,-0.771,0.561);
		c.lineTo(-0.666,0.701);
		c.quadraticCurveTo(0.5,0.705,0.631,0.714);
		c.lineTo(0.67,0.685);
		c.quadraticCurveTo(0.5,0.69,-0.16,0.666);				//criar ponte
		c.lineTo(0.701,0.657);
		c.moveTo(-0.947,0.140);
		c.quadraticCurveTo(-0.8,0.04,-0.603,-0.387);
		c.lineTo(-0.603, -0.357)
		c.quadraticCurveTo(-0.8,0.04,-0.947,0.201);
	c.closePath();
}

function Barra(c){
	c.beginPath();
		c.moveTo(-0.6,0.736);
		c.lineTo(-0.6,-0.508);
		c.lineTo(-0.543,-0.508);								//criar barra
		c.lineTo(-0.526,0.824)
	c.closePath();
}


function Cabo(c){
	c.beginPath(c);
		c.moveTo(-0.456,-0.350);
		c.lineTo(-0.433,-0.321);		//criar cabo
		c.lineTo(-0.175,0.51);
		c.lineTo(-0.192,0.51);
	c.closePath(c);
}

function Cab(c,x,y,w,z,k,Inc_x,Inc_y,Inc_z,angulo,Inc_Ang){            //loop para cirar varios cabos

	var i = 0;
	
	while(i<k){

		enter(c,x,y,w,z);
		c.rotate(angulo * Math.PI/180);
		Cabo(c);
		leave(c, "#f8c536", "#f8c536");               

		x = x + Inc_x;
		y = y + Inc_y;
		z = z - Inc_z;
		i = i + 1;
		angulo = angulo - Inc_Ang;

	}
	
}

function textoCircular(c,texto,x,y,alpha,espaco,orientacao,font,fillStyle){
    espaco = espaco || 0;
    c.font = font;
    c.fillStyle = fillStyle;
    var alphaPorLetra = (Math.PI - espaco * 2) / texto.length;
    c.save();
    c.translate(x,y);
    var k = orientacao 
    c.rotate(-k * ((Math.PI - alphaPorLetra) / 2 - espaco));				

    for(var i=0;i<texto.length;i++){
        c.save();
        c.rotate(k*i*(alphaPorLetra));
        c.textAlign = "center";
        c.textBaseline = (!orientacao) ? "top" : "bottom";
        c.fillText(texto[i],0,-k*(alpha));
        c.restore();
        }
    c.restore();
}

scene = function(c2d, pos, frame_func) {
    //
    //  atributos
    //
    this.c2d = c2d;
    this.pos = pos;
    this.frame_func = frame_func;
    //
    //  métodos
    //
    this.animate = function() {
        //  "ciclo de animação"
        //
        this.frame_func();
        //  redesenhar quando possível
        requestAnimationFrame(this.animate);
        //  atualizar os parâmetros
        TWEEN.update();        
    }
    //
    //  "truque"
    //
    return this;
}


function GSW(c){                 //Emblema em concreto
	
	enter(c, 400,401, 203,203);
	Circulo(c);
	leave(c, "#243F90", "#243F90");

	enter(c, 400,396.5, 188,188);
	Circulo(c);
	leave(c, "#f8c536", "#f8c536");

	enter(c, 400,396.5, 178,178);
	Circulo(c);
	leave(c, "#243F90","#243F90");

    textoCircular(c, "WARRIORS",400,422,258,Math.PI/4.9,-1,"Bold 70px  Copperplate","#243F90");
 
    textoCircular(c, "GOLDEN STATE",400,410,210,Math.PI/5.5,1,"normal 50px  Copperplate","#243F90");

    enter(c, 400,396.5, 188, 188);
	Ponte(c);
	leave(c, "#f8c536", "#f8c536");

	enter(c, 400, 397, 188,188);
	Barra(c);
	leave(c, "#f8c536", "#f8c536");

	enter(c, 394, 400, 150,198);
	c.rotate(-2 * Math.PI/180);
	Barra(c);
	leave(c, "#f8c536", "#f8c536");

	enter(c,298, 302, 6,5)
	retangulo(c);
	leave(c, "#f8c536", "#f8c536");

	enter(c,305.5, 301.5, 4,2);
	triangulo(c);
	leave(c, "#f8c536", "#f8c536");


	Cab(c,399,406.5,190,177,3,17,14.5,7,3.5,0);

	Cab(c,445.5,442.5,180,120,4,16,7.5,7,5.8,0);

	Cab(c,513,473,190,58,3,18,10,0,10.5,0);

	Cab(c,380,455,175,90,1,0,0,0,10,0);

	Cab(c,385,426,175,150,1,0,0,0,4.1,0);

	Cab(c,170,430,-188,36,2,11.5,-4,-45,14,3.4);

	Cab(c,195,418,-188,150,2,15,-6,-50,6.7,2.3);

	Cab(c,220.5,455,-175,132,1,0,0,0,8.8,0);
}

function GSW_animado(){ //Gradiente e começo da animação

    var gradient = c2d.createRadialGradient(400, 400, 400, 400, 400, 0);
    gradient.addColorStop(0.1, "white");
    gradient.addColorStop(0.45, "#f8c536");
    this.c2d.fillStyle = gradient;
    this.c2d.ellipse( 400,400, 380,380, 0, 0,2*Math.PI);
    this.c2d.fill();

	enter(this.c2d, pos.x, pos.y, 1, 1);
    GSW(this.c2d);
    this.c2d.restore();
}

function main() {
    var c2d = document.getElementById("acanvas").getContext("2d");
    

    //  Parâmetros da animação
    //
    //      animar a posição
    //
    var pos = {x: -80, y: -80};
    var target_pos= { x: 0, y: 0};
    var pos_t = new TWEEN.Tween(pos).to(target_pos, 2500);
    pos_t.easing(TWEEN.Easing.Elastic.InOut);
    pos_t.start();

    //
    var s = scene(c2d,pos, GSW_animado);
    //
    //  Animação
    //
    s.animate();
}