using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
public class VertexShader : MonoBehaviour
{
    [SerializeField] ParticleSystem emit;
    [SerializeField] float circleSize = 0.05f;

    void Start()
    {
        Mesh mesh = GetComponent<MeshFilter>().sharedMesh;
        if (mesh == null || emit == null) return;

        var main = emit.main;
        main.simulationSpace = ParticleSystemSimulationSpace.Local;

        Vector3[] vertices = mesh.vertices;
        for (int i = 0; i < vertices.Length; i++)
        {
            var emitParams = new ParticleSystem.EmitParams
            {
                position = vertices[i],
                startSize = circleSize,
            };
            emit.Emit(emitParams, 1);
        }
    }
}