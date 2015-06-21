class DFIR.Camera extends DFIR.Object3D
  constructor: (@viewportWidth, @viewportHeight) ->
    super()
    
    @viewportWidth ?= gl.viewportWidth
    @viewportHeight ?= gl.viewportHeight
    
    @target = vec3.create()
    @fov = 45.0
    @up = vec3.create [0.0, 1.0, 0.0]
    @viewMatrix = mat4.create()
    @near = 0.01
    @far = 60.0
    @updateViewMatrix()
    @projectionMatrix = mat4.create()
    @updateProjectionMatrix()
    
  setFarClip: (@far) ->
    @updateProjectionMatrix()
    
  setNearClip: (@near) ->
    @updateProjectionMatrix()
    
  getViewMatrix: ->
    @viewMatrix
    
  getProjectionMatrix: ->
    @projectionMatrix
    
    
  getFrustumCorners: ->
    v = vec3.create()
    vec3.sub @target, @position, v
    vec3.normalize v
    w = vec3.create()
    vec3.cross viewVector, @up, w
    fov = @fov * Math.PI / 180.0
    ar = @viewportWidth / @viewportHeight
    
    Hnear = 2 * Math.tan(fov / 2.0) * @near
    Wnear = Hnear * ar
    
    Hfar = 2 * Math.tan(fov / 2.0) * @far
    Wfar = Hfar * ar
    
    Cnear = vec3.create()
    Cfar = vec3.create()
    
    vec3.add @position, v, Cnear
    vec3.scale Cnear, @near
    
    vec3.add @position, v, Cfar
    vec3.scale Cfar, @far
    
    #And now we get our points

    #Near Top Left = Cnear + (up * (Hnear / 2)) - (w * (Wnear / 2))
    
    #Near Top Right = Cnear + (up * (Hnear / 2)) + (w * (Wnear / 2))
    
    #Near Bottom Left = Cnear - (up * (Hnear / 2)) - (w * (Wnear /2))
    
    #Near Bottom Right = Cnear + (up * (Hnear / 2)) + (w * (Wnear / 2))
    
    #Far Top Left = Cfar + (up * (Hfar / 2)) - (w * Wfar / 2))
    
    #Far Top Right = Cfar + (up * (Hfar / 2)) + (w * Wfar / 2))
    
    #Far Bottom Left = Cfar - (up * (Hfar / 2)) - (w * Wfar / 2))
    
    #Far Bottom Right = Cfar - (up * (Hfar / 2)) + (w * Wfar / 2))
    
  getInverseProjectionMatrix: ->
    invProjMatrix = mat4.create()
    mat4.inverse @projectionMatrix, invProjMatrix
    invProjMatrix
    
  updateViewMatrix: ->
    mat4.identity @viewMatrix
    mat4.lookAt @position, @target, @up, @viewMatrix
    
  updateProjectionMatrix: () ->
    mat4.identity @projectionMatrix
    aspect = @viewportWidth / @viewportHeight
    mat4.perspective @fov, @viewportWidth / @viewportHeight, @near, @far, @projectionMatrix
    
    
  
    
  
    
    
