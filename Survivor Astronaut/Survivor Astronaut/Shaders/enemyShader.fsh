void main()
{
    float currTime = u_time;


    // Calcula os pixels que devem aparecer baseado na posicao xy do pixel
    vec2 pos = mod(gl_FragCoord.xy, vec2(20.0)) - vec2(10.0);
    float dist_squared = dot(pos, pos);
    
    // Cor RGB calculada variando o G e B
    vec3 myColor = vec3(0.9, 0.5 + 0.5 * sin(currTime), 0.5 + 0.5 * cos(currTime));
    
    // gl_FragColor é a cor final do pixel, aqui verificamos se o ponto pertence
    // a parte interna de um circulo, e retornamos a cor, caso não pertença
    // retornamos transparente
    gl_FragColor = (dist_squared < 60.0)
    ? vec4(myColor, 1)
    : vec4(0, 0, 0, 0);
}