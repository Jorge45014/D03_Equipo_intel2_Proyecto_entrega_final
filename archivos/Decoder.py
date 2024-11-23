import tkinter as tk
from tkinter import *
from tkinter import filedialog
from tkinter import messagebox
import re

class Deco:
    def __init__(self):
        self.original_lines = {}
        self.binary_results = {}
        self.combined_results = {}
        self.resultado_binario = ""
        self.window = tk.Tk()
        self.textArea = tk.Text(self.window, wrap=tk.WORD, height=25, width=80)
        self.createWindow()
        self.showGui()

    def createWindow(self):
        self.window.title("Decoder")
        self.window.geometry("700x600")

        titleLabel = tk.Label(self.window, text="Text Analyzer", font=("Arial", 16))
        titleLabel.pack(pady=10)

        button1 = tk.Button(self.window, text="Import file", command=self.selectFile)
        button1.pack(pady=10)

        frame = Frame(self.window)
        frame.pack(pady=10)

        opcion1 = Button(frame, text="Save operation", command=lambda: self.saveFile(1))
        opcion1.pack(side=LEFT, padx=10)

        opcion2 = Button(frame, text="Save result", command=lambda: self.saveFile(2))
        opcion2.pack(side=LEFT, padx=10)

        opcion3 = Button(frame, text="Save Both", command=lambda: self.saveFile(3))
        opcion3.pack(side=LEFT, padx=10)

        button3 = tk.Button(self.window, text="Decode", command=self.decode)
        button3.pack(pady = 10)

        self.textArea.pack(pady=10)

    def selectFile(self):
        # Cambia el filtro de tipos de archivo para aceptar tanto .txt como .asm
        file = filedialog.askopenfilename(filetypes=[("Text Files", "*.txt"), ("ASM Files", "*.asm")], title="Select file")
        if file:
            self.loadFile(file)

    def loadFile(self, file):
        with open(file, 'r', encoding='utf-8') as file_:
            content = file_.read()
        self.textArea.delete('1.0', tk.END)
        self.textArea.insert(tk.END, content)

    def saveFile(self, opcion):
        # Cambia la extensión por defecto para aceptar .txt o .asm
        file = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Text Files", "*.txt"), ("ASM Files", "*.asm")])
        if file:
            with open(file, 'w', encoding='utf-8') as file_:
                if opcion == 1:
                    for line, resultado in self.original_lines.items():
                        file_.write(f"{resultado}\n")
                elif opcion == 2:
                    for line, resultado in self.binary_results.items():
                        file_.write(f"{resultado}\n")
                elif opcion == 3:
                    for line, resultado in self.combined_results.items():
                        file_.write(f"{resultado}\n")

    def decode(self):
        keywords = {
            # Tipo I
            "addi": "001000",
            "slti": "001010",
            "andi": "001100",
            "ori":  "001101",
            "sw":   "101011",
            "lw":   "100011",
            "beq":  "000100",
            # Tipo R
            "add": "000000_100000",
            "sub": "000000_100010",
            "slt": "000000_101010",
            "and": "000000_100100",
            "xor": "000000_100110",
            "nor": "000000_100111",
            "or":  "000000_100101",
            "nop": "000000_000000"
        }

        content = self.textArea.get("1.0", tk.END).strip()  # Obtén todo el contenido
        lines = content.splitlines()

        for line_num, line in enumerate(lines):
            line_lower = line.lower()  # Convierte la línea a minúsculas

            if not line_lower.strip():  # Ignorar líneas vacías
                continue

            for keyword, code in keywords.items():
                if keyword in line_lower:  # Usar la línea en minúsculas para buscar
                    count_dollar = 0  # Contador de símbolos $
                    pos = 0  # Posición para comenzar la búsqueda en la línea 

                    if keyword == "nop":
                        count_dollar = 3
                        num1 = "00000"
                        num2 = "00000"
                        num3 = "00000"

                    # Tipo I ///////////////////////////////
                    if len(code) == 6:
                        immediate_value = None  # Para capturar el valor inmediato
                        while count_dollar < 2:
                            dollar_index = line.find("$", pos)
                            if dollar_index != -1:
                                count_dollar += 1
                                pos = dollar_index + 1

                                rest_of_line = line[pos:].strip()
                                match = re.match(r'(\d+)', rest_of_line)

                                if match:
                                    number_after_dollar = match.group(1)
                                    pos += len(number_after_dollar)
                                    if count_dollar == 1:
                                        num1 = number_after_dollar  # Registro destino
                                    elif count_dollar == 2:
                                        num2 = number_after_dollar  # Registro fuente
                                else:
                                    messagebox.showerror("Error", "No hay número después de $.")
                                    return
                            else:
                                break

                        # Captura el valor inmediato (después de #)
                        immediate_index = line.find("#", pos)
                        if immediate_index != -1:
                            rest_of_line = line[immediate_index + 1:].strip()
                            match = re.match(r'(-?\d+)', rest_of_line)
                            if match:
                                immediate_value = match.group(1)
                            else:
                                messagebox.showerror("Error", "No hay valor inmediato válido.")
                                return
                        else:
                            messagebox.showerror("Error", "Falta el valor inmediato (#).")
                            return

                        if immediate_value is None:
                            messagebox.showerror("Error", "Instrucción tipo I incompleta.")
                            return

                        # Construir binario para tipo I
                        resultado_binario = f"{code}{self.convertBinary(int(num2), 5)}{self.convertBinary(int(num1), 5)}{self.convertBinary(int(immediate_value), 16)}\n"
                    else: # Tipo R
                        while count_dollar < 3:  # Se esperan 3 símbolos $
                            dollar_index = line.find("$", pos)
                            if dollar_index != -1:
                                count_dollar += 1
                                pos = dollar_index + 1  # Mover la posición después del $

                                rest_of_line = line[pos:].strip()  # Buscar el número después del $
                                match = re.match(r'(\d+)', rest_of_line)
                                 
                                if match:
                                    number_after_dollar = match.group(1)
                                    pos += len(number_after_dollar)  # Actualiza la posición después del número
                                    if count_dollar == 1:  # Guardar los números en variables
                                        num1 = number_after_dollar
                                    elif count_dollar == 2:
                                        num2 = number_after_dollar
                                    elif count_dollar == 3:
                                        num3 = number_after_dollar
                                else:
                                    messagebox.showerror("Error", "No hay número después de $.")
                                    return
                            else:
                                break

                        if count_dollar != 3:
                            messagebox.showerror("Error", "Operación incompleta, faltan símbolos $.")
                            return

                        resultado_binario = f"{code[:6]}{self.convertBinary(int(num2), 5)}{self.convertBinary(int(num3), 5)}{self.convertBinary(int(num1), 5)}{'00000'}{code[-6:]}\n"

                    if line_num not in self.binary_results or self.binary_results[line_num] != resultado_binario.strip():
                        if "=" in line:
                            self.original_lines[line_num] = line.split('=')[0].strip()
                            self.textArea.insert(f"{line_num + 1}.0", self.combined_results[line_num])
                        else:
                            self.original_lines[line_num] = line
                        self.binary_results[line_num] = resultado_binario.strip()  # Actualiza directamente
                        self.combined_results[line_num] = f"{self.original_lines[line_num]} = {self.binary_results[line_num]}"
                        self.textArea.delete(f"{line_num + 1}.0", f"{line_num + 1}.end")  # Limpiar la línea
                        self.textArea.insert(f"{line_num + 1}.0", self.combined_results[line_num])  # Mostrar el resultado combinado
                    else:
                        self.textArea.delete(f"{line_num + 1}.0", f"{line_num + 1}.end")  # Limpiar la línea
                        self.textArea.insert(f"{line_num + 1}.0", self.combined_results[line_num]) 

                    break  # Salir del bucle de keywords, ya que se ha encontrado uno

            else:
                messagebox.showwarning("Error", "Operación no válida.")

    def convertBinary(self, number, bits):
        if isinstance(number, int):
            # Verificar rango
            max_value = (1 << bits) - 1
            min_value = -(1 << (bits - 1))
            if not (min_value <= number <= max_value):
                messagebox.showwarning("Error", f"{number} fuera de rango para {bits} bits.")
                return None
            return f"{number & max_value:0{bits}b}"
        else:
            messagebox.showerror("Error", "Valor no válido para conversión.")
            return None

    def showGui(self):
        self.window.mainloop()

if __name__ == "__main__":
    deco = Deco()
