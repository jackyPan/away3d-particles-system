package a3dparticle.animators.actions 
{
	import away3d.core.base.IRenderable;
	import away3d.core.managers.Stage3DProxy;
	import away3d.materials.passes.MaterialPassBase;
	import away3d.materials.utils.ShaderRegisterElement;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author ...
	 */
	public class VelocityAction extends PerParticleAction
	{
		private var _velFun:Function;
		
		private var _tempVelocity:Vector3D;
		
		private var velocityAttribute:ShaderRegisterElement;
		
		public function VelocityAction(fun:Function) 
		{
			dataLenght = 3;
			_velFun = fun;
		}
		
		override public function genOne(index:uint):void
		{
			_tempVelocity = _velFun(index);
		}
		
		override public function distributeOne(index:int, verticeIndex:uint):void
		{
			_vertices.push(_tempVelocity.x);
			_vertices.push(_tempVelocity.y);
			_vertices.push(_tempVelocity.z);
		}
		
		override public function getAGALVertexCode(pass : MaterialPassBase) : String
		{
			
			var distance:ShaderRegisterElement = shaderRegisterCache.getFreeVertexVectorTemp();
			distance = new ShaderRegisterElement(distance.regName, distance.index, "xyz");
			velocityAttribute = shaderRegisterCache.getFreeVertexAttribute();
			var code:String = "";
			code += "mul " + distance.toString() + "," + _animation.vertexTime.toString() + "," + velocityAttribute.toString() + "\n";
			code += "add " + _animation.postionTarget.toString() +".xyz," + distance.toString() + "," + _animation.postionTarget.toString() + ".xyz\n";
			return code;
		}
		
		override public function setRenderState(stage3DProxy : Stage3DProxy, pass : MaterialPassBase, renderable : IRenderable) : void
		{
			stage3DProxy.setSimpleVertexBuffer(velocityAttribute.index, getVertexBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_3);
		}
		
	}

}