# Instruction Set Architecture (ISA) Documentation

## 1. ISA Overview

| Property | Description |
|---|---|
| ISA Name | |
| Architecture | |
| Data Width | 32-bit |
| Instruction Length | 32 bits |
| Number of Registers | |
| Register Width | |
| Addressing Mode | |
| Endianness | |

---

## 2. Instruction Formats

All instructions are 32-bit wide and use one of the following formats.

### 2.1 R-Type

**Register-to-Register Instructions**

| Field | Bit Range | Width |
|---|---|---:|
| opcode | [31:26] | 6 |
| funct3 | [25:23] | 3 |
| rd | [22:17] | 6 |
| rs1 | [16:11] | 6 |
| rs2 | [10:5] | 6 |
| funct5 | [4:0] | 5 |
| **Total** | | **32** |

### 2.2 I-Type

**Immediate Instructions**

| Field | Bit Range | Width |
|---|---|---:|
| opcode | [31:26] | 6 |
| funct3 | [25:23] | 3 |
| rd | [22:17] | 6 |
| rs1 | [16:11] | 6 |
| imm | [10:0] | 11 |
| **Total** | | **32** |

### 2.3 B-Type

**Conditional Branch Instructions**

| Field | Bit Range | Width |
|---|---|---:|
| opcode | [31:26] | 6 |
| imm | [25:17] | 9 |
| rs1 | [16:11] | 6 |
| rs2 | [10:5] | 6 |
| imm | [4:0] | 5 |
| **Total** | | **32** |

### 2.4 J-Type

**Unconditional Jump Instructions**

| Field | Bit Range | Width |
|---|---|---:|
| opcode | [31:26] | 6 |
| imm | [25:0] | 26 |
| **Total** | | **32** |

---

## 3. Instruction Categories

### 3.1 Arithmetic Instructions

| Instruction | Format | opcode | funct3 | funct5 | Operation | Description |
|---|---|---|---|---|---|---|
| ADD | R-Type | | | | rd = rs1 + rs2 | |
| SUB | R-Type | | | | rd = rs1 - rs2 | |
| ADDI | I-Type | | | N/A | rd = rs1 + imm | |
| ... | | | | | | |

### 3.2 Logical Instructions

| Instruction | Format | opcode | funct3 | funct5 | Operation | Description |
|---|---|---|---|---|---|---|
| AND | R-Type | | | | rd = rs1 AND rs2 | |
| OR | R-Type | | | | rd = rs1 OR rs2 | |
| XOR | R-Type | | | | rd = rs1 XOR rs2 | |
| ANDI | I-Type | | | N/A | rd = rs1 AND imm | |
| ORI | I-Type | | | N/A | rd = rs1 OR imm | |
| XORI | I-Type | | | N/A | rd = rs1 XOR imm | |
| ... | | | | | | |

### 3.3 Shift Instructions

| Instruction | Format | opcode | funct3 | funct5 | Operation | Description |
|---|---|---|---|---|---|---|
| SLL | R-Type | | | | rd = rs1 << rs2 | |
| SRL | R-Type | | | | rd = rs1 >> rs2 | |
| SRA | R-Type | | | | rd = signed(rs1) >>> rs2 | |
| SLLI | I-Type | | | N/A | rd = rs1 << imm | |
| SRLI | I-Type | | | N/A | rd = rs1 >> imm | |
| SRAI | I-Type | | | N/A | rd = signed(rs1) >>> imm | |

### 3.4 Comparison Instructions

| Instruction | Format | opcode | funct3 | funct5 | Operation | Description |
|---|---|---|---|---|---|---|
| SLT | R-Type | | | | rd = (rs1 < rs2) ? 1 : 0 | Signed comparison |
| SLTU | R-Type | | | | rd = (rs1 < rs2) ? 1 : 0 | Unsigned comparison |
| SLTI | I-Type | | | N/A | rd = (rs1 < imm) ? 1 : 0 | Signed comparison |
| SLTIU | I-Type | | | N/A | rd = (rs1 < imm) ? 1 : 0 | Unsigned comparison |

### 3.5 Load Instructions

| Instruction | Format | opcode | funct3 | Operation | Description |
|---|---|---|---|---|---|
| LB | I-Type | | | rd = SignExtend(Mem[rs1 + imm]) | |
| LH | I-Type | | | rd = SignExtend(Mem[rs1 + imm]) | |
| LW | I-Type | | | rd = SignExtend(Mem[rs1 + imm]) | |
| LBU | I-Type | | | rd = ZeroExtend(Mem[rs1 + imm]) | |
| LHU | I-Type | | | rd = ZeroExtend(Mem[rs1 + imm]) | |

### 3.6 Store Instructions

| Instruction | Format | opcode | funct3 | Operation | Description |
|---|---|---|---|---|---|
| SB | I-Type | | | Mem[rs1 + imm] = rs2[7:0] | |
| SH | I-Type | | | Mem[rs1 + imm] = rs2[15:0] | |
| SW | I-Type | | | Mem[rs1 + imm] = rs2[31:0] | |

### 3.7 Branch Instructions

| Instruction | Format | opcode | Operation / Condition | Description |
|---|---|---|---|---|
| BEQ | B-Type | | if (rs1 == rs2) PC = PC + imm | |
| BNE | B-Type | | if (rs1 != rs2) PC = PC + imm | |
| BLT | B-Type | | if (rs1 < rs2) PC = PC + imm | Signed comparison |
| BGE | B-Type | | if (rs1 >= rs2) PC = PC + imm | Signed comparison |
| BLTU | B-Type | | if (rs1 < rs2) PC = PC + imm | Unsigned comparison |
| BGEU | B-Type | | if (rs1 >= rs2) PC = PC + imm | Unsigned comparison |

### 3.8 Jump Instructions

| Instruction | Format | opcode | Operation | Description |
|---|---|---|---|---|
| JAL | J-Type | | rd = PC + 4; PC = PC + imm | |
| JALR | I-Type | | rd = PC + 4; PC = (rs1 + imm) & ~1 | |

### 3.9 Multiplication and Division Instructions

| Instruction | Format | opcode | funct3 | funct5 | Operation | Description |
|---|---|---|---|---|---|---|
| MUL | R-Type | | | | rd = rs1 * rs2 | |
| MULH | R-Type | | | | rd = High(rs1 * rs2) | |
| MULHSU | R-Type | | | | rd = High(signed(rs1) * unsigned(rs2)) | |
| MULHU | R-Type | | | | rd = High(unsigned(rs1) * unsigned(rs2)) | |
| DIV | R-Type | | | | rd = rs1 / rs2 | Signed division |
| DIVU | R-Type | | | | rd = rs1 / rs2 | Unsigned division |
| REM | R-Type | | | | rd = rs1 % rs2 | Signed remainder |
| REMU | R-Type | | | | rd = rs1 % rs2 | Unsigned remainder |

---

## 4. Instruction Operation Details

Use this section to document the detailed behavior of each instruction.

### [Instruction Name]

| Property | Description |
|---|---|
| Instruction Format | |
| Opcode | |
| funct3 | |
| funct5 | N/A / Value |
| Destination Register (rd) | |
| Source Register 1 (rs1) | |
| Source Register 2 (rs2) | |
| Immediate Width | |
| Immediate Type | Signed / Unsigned |
| Operation | |

**Functional Description:**

Describe the instruction's behavior.

**Pseudocode:**

```text
rd = ...
```

**Example:**

```asm
INSTRUCTION rd, rs1, rs2
```

---

## 5. Immediate Generation

| Format | Immediate Bit Fields | Immediate Width | Sign Extension |
|---|---|---:|---|
| I-Type | imm[10:0] | 11 | |
| B-Type | imm[25:17], imm[4:0] | 14 | |
| J-Type | imm[25:0] | 26 | |

**Immediate Reconstruction:**

```text
I-Type:
imm = instruction[10:0]

B-Type:
imm = {instruction[25:17], instruction[4:0]}

J-Type:
imm = instruction[25:0]
```

---

## 6. ISA Coverage Summary

| Category | Number of Instructions | Supported |
|---|---:|---|
| Arithmetic | | |
| Logical | | |
| Shift | | |
| Comparison | | |
| Load | | |
| Store | | |
| Branch | | |
| Jump | | |
| Multiplication | | |
| Division | | |
| Custom | | |
| **Total** | | |

---

## 7. Custom Instructions

| Instruction | Format | opcode | funct3 | funct5 | Operation | Description |
|---|---|---|---|---|---|---|
| | | | | | | |

---

## 8. Unsupported Instructions

| Instruction | Original Extension | Reason |
|---|---|---|
| | | |