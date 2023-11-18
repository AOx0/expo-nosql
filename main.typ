#import "slides.typ": *
#import "tablex.typ": *
#import "themes/bristol.typ": *

#show: slides.with(
    authors: ("Alejandro Osornio"), short-authors: "Alejandro Osornio",
    title: "NoSQL", short-title: "NoSQL", subtitle: "",
    date: "2023-11-21",
    theme: bristol-theme(),
)

#slide(theme-variant: "title slide")

#new-section("Introducción")

#slide(title: "SQL")[
  - Las computadoras son _software_ y _hardware_
  - Escribir programas para la computadora implica escribir instrucciones
  - Un programa no es más que una secuencia de instrucciones para el procesador.
  - El lenguaje ensamblador es el de *más bajo nivel* que permite escribir programas para una computadora, de la forma más cercana al hardware, usando texto plano que es compilado.
]

#slide(title: "Assembler")[
  - El ensamblador es el programa encargado de *compilar un programa escrito en el lenguaje ensamblador*, es decir, traducir las instrucciones dadas en forma de texto plano, entendible por humanos, a código binario, el lenguaje de máquina que el procesador puede manejar y ejecutar.
  - Al archivo compilado se le llama binario o ejecutable.
]

#slide(title: "El proyecto", colwidths: (1fr, 5%, 1fr))[
  ```yasm
  section .data
  msg db "Hola mundo!", 0xA

  section .text
  global _start
  
  _start:
    mov rax, 0x1
    lea rdi, [rip + msg]
    mov rsi, 0xC
    syscall
  ```
][
  #align(center + horizon)[?$arrow.r$]
][
  ```
  01001000 01101111 01101100 01100001 00100000 01110000 01101111 01110010 00100000 01100110 01100001 01110110 01101111 01110010 00100000 01101110 01101111 00100000 01110100 01110010 01100001 01110011 01110000 01101111 01110010 00100000 01100110 01100001 01110110 01101111 01110010 00100000 01101110
  ```
]

#new-section("ELF")

#slide(title: "Binario")[
  - El sistema operativo tiene formas determinadas de ejecutar código, por ejemplo, *no cualquier archivo con 1s y 0s de información se ejecuta* por que sí.
  - Se le debe dar de la forma y lugar correcto la información necesaria para que el sistema operativo inicie un proceso con código
  - En linux, el formato para darle programas al sistema operativo es el ELF, *Executable and Linkable Format*.
]

#slide(title: "ELF", colwidths: (2fr, 1fr))[
  - Un archivo con el formato *ELF* hace que la computadora realice tareas indicadas según instrucciones codificadas.
  - Ejecución:
    - La firma del archivo se parsea y carga
    - Las secciones de información especificadas se mapean a la memoria
    - Se pone `CIR` en la dirección de entrada
][
  #align(center + horizon)[
    #image("Elfl.svg", width: 100%)
  ]
]

#slide(title: "")[
  #align(center, [
  #image("ELF.png", height: 70%)
  ])
]

#slide(title: "m4b/faerie")[
  #set text(size: 20pt)
```rs
let mut obj = ArtifactBuilder::new(triple!("x86_64-unknown-...")).finish();

obj.declarations(
    [("main",    Decl::function().global().into()),
    ("printf",   Decl::function_import().into()) ].iter().cloned()
)?;

obj.define("main", vec![0x55, 0xc3])?;
obj.define("str.1", b"deadbeef: 0x%x\n\0".to_vec())?;

obj.link(Link { from: "main", to: "printf", at: 29 })?;
obj.link(Link { from: "deadbeef", to: "DEADBEEF", at: 7 })?;

obj.write(file)?;
```
]

#new-section("Parse")

#slide(title: "Parse", colwidths: (1fr, 5%, 1fr))[
  - Primero debemos pasar el texto del archivo a una representación que nos permita identificar y trabajar las instrucciones desde el software. A este proceso se le llama generar el *Abstract Syntax Tree o AST*.
][
  
][
```rs
enum Line {
  Mnemonic(Mnemonic),
  DataDefine(DataDefine),
  Extern(String),
  Comment(String),
  Function(Fun),
  Global(String),
  Empty,
}
```
]

#slide(title: "Parse")[
  #set text(size: 20pt)
```yasm
extern scanf                ;;  { line: Line::Extern(_),     line_num: 1 }
extern exit                 ;;  { line: Line::Extern(_),     line_num: 2 }
                            ;;  { line: Line::Empty,         line_num: 3 }
numb dw 0x0                 ;;  { line: Line::DataDefine(_), line_num: 4 }
scan db "%d", 0             ;;  { line: Line::DataDefine(_), line_num: 5 }
                            ;;  { line: Line::Empty,         line_num: 6 }
main:                       ;;  { line: Line::Function(_),   line_num: 7 }
    mov rax, 0              ;;  { line: Line::Mnemonic(_),   line_num: 8 }
    lea rdi, [rip + scan]   ;;  { line: Line::Mnemonic(_),   line_num: 9 }
    lea rsi, [rip + numb]   ;;  { line: Line::Mnemonic(_),   line_num: A }
    call scanf              ;;  { line: Line::Mnemonic(_),   line_num: B }
    call exit               ;;  { line: Line::Mnemonic(_),   line_num: C }
```
]

#new-section("Codificar")

#slide(title: "Codificar")[
  #set text(size: 20pt)
  ```rs
  fn assemble(&mut self) -> Result<&mut Vec<u8>> {
        self.bytecode.clear();

        let lines = take(&mut self.lines);
        for line in lines.into_iter() {
            if let Err(e) = self.assemble_line(line.line) {
                bail!("Error on line {}: {}", line.line_num, e);
            }
        }

        Ok(&mut self.bytecode)
    }
  ```
]

#slide(title: "Codificar")[
  #set text(size: 20pt)
  Encoding:
  #tablex(
  columns: (1fr,) * 6, 
  rows: (1.5em),
  align: center,
    [Prefix], [*Opcode*], [ModR/M], [*SIB*], [Displacement], [Immediate]
  )

  ModR/M:
  #tablex(
  columns: (1fr,) * 8, 
  rows: (1.5em),
  align: center,
    [Mod], [Mod], [*Reg*], [*Reg*], [*Reg*], [R/M], [R/M], [R/M]
  )

  SIB
  #tablex(
    columns: (1fr,) * 8, 
    rows: (1.5em),
    align: center,
    [Scale], [Scale], [*Index*], [*Index*], [*Index*], [Base], [Base], [Base]
  )
]

#slide(theme-variant: "wake up")[
  Gracias!

  #set text(size: 12pt)

  - Wikipedia (2023-07-13). _Executable and Linkable Format_. https://en.wikipedia.org/w/index.php?title=Executable_and_Linkable_Format&oldid=1162401948
  - Wikipedia (2023-07-13). _Executable_. https://en.wikipedia.org/w/index.php?title=Executable&oldid=1155627042
  - X86-64 Instruction Encoding. _osdev.org_. https://wiki.osdev.org/X86-64_Instruction_Encoding#Table10Note2 el día 13/07/2023

  - Irma Patricia Quiroga. (2010). Arquitectura de computadoras. Alfaomega.
  - Morris Mano, M. (1994). Arquitectura de computadores. Prentice-Hall Hispanoamericana.
  - Intel Corporation (2023). Intel® 64 and IA-32 Architectures Software Developer’s Manual. Combined Volumes: 1-4
]
