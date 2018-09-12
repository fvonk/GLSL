#version 410

attribute vec3 TexCoord;
varying vec4 FragColor;

uniform BlobSettings {
  vec4 InnerColor;
  vec4 OuterColor;
  float RadiusInner;
  float RadiusOuter;
} Blob;

void main() {
    float dx = TexCoord.x - 0.5;
    float dy = TexCoord.y - 0.5;
    float dist = sqrt(dx * dx + dy * dy);
    gl_FragColor =
       mix( Blob.InnerColor, Blob.OuterColor,
             smoothstep( Blob.RadiusInner, Blob.RadiusOuter, dist )
            );
}
