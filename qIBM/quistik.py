from qiskit import QuantumCircuit, transpile
from qiskit_ibm_runtime import SamplerV2 as Sampler, QiskitRuntimeService

# Corregido: usa "ibm_quantum_platform" en lugar de "ibm_quantum"
QiskitRuntimeService.save_account(
    channel="ibm_quantum_platform", 
    token="T3balR1JRFYkUmDhQv-8NGX4zoHfXJzlDsoZPeObwLFa", 
    overwrite=True
)

# Conectar al servicio (la cuenta ya está guardada)
service = QiskitRuntimeService()
backend = service.least_busy(operational=True, simulator=False, min_num_qubits=127)

print(f"Usando backend: {backend.name}")

# Crear el circuito cuántico
qc = QuantumCircuit(2, 2)
qc.h(0)
qc.cx(0, 1)
qc.measure([0, 1], [0, 1])

# IMPORTANTE: Transpilar el circuito para que sea compatible con el hardware
qc_transpiled = transpile(qc, backend=backend, optimization_level=3)

print("Circuito transpilado exitosamente")
print(qc_transpiled)

# Crear el sampler y ejecutar
sampler = Sampler(mode=backend)
pub = (qc_transpiled,)
job = sampler.run([pub], shots=1024)

print(f"Job ID: {job.job_id()}")
print("Esperando resultados...")

result = job.result()
print("\n=== RESULTADOS ===")
print(result)