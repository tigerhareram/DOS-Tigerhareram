{ **** External Linked ASM procedures **** }
{$F+}
(*
{$L BYTESORT.OBJ}
Procedure ByteSort(Var View : ViewObject); External;
*)

{$L i_XFORM.OBJ}
Procedure InvXForm(Var V : Vertex3d; M : Matrix4x3); External;
Procedure XForm(Var Obj : VectorObject; M : Matrix4x3); External;
Procedure Project(Var View : ViewObject; Obj : VectorObject); External;
Procedure SingleProject(X3D, Y3D, Z3D, CX, CY : Longint; Var SX, SY : Integer); External;

{$L i_Vector.Obj}
Function  DotProduct8(Var A : Vertex3d; Var B : ShortVertex3d) : Integer; External;
Procedure CullPolys(Obj : VectorObject; CullVector : Vertex3d); External;

{$L i_MATRIX.OBJ}
Procedure SetRotationMatrix(Var M : Matrix4x3; xa, ya, za : Integer); External;
Procedure MatrixMul(Var Result : Matrix4x3; A, B : Matrix4x3); External;
Procedure SingleRotate(Var Vector : Vertex3d; Xa, Ya, Za : Integer); External;
{$F-}
