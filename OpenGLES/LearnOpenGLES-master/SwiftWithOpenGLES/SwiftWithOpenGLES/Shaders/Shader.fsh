//
//  Shader.fsh
//  SwiftWithOpenGLES
//
//  Created by loyinglin on 16/4/12.
//  Copyright © 2016年 loyinglin. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
