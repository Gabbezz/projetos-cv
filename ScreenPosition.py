#Useful if you want to find the X and Y axes of your screen.

import pyautogui 
import time 
import sys

pyautogui.FAILSAFE = True 
print("Iniciando o rastreador de posição do mouse.") 
print("Mova o mouse para o local desejado e anote os valores.")

print("Pressione Ctrl + C no terminal para parar o script.")

while True:
    posicao = pyautogui.position()
    posicao_str = f"X:{posicao.x} Y: {posicao.y}"
    
    sys.stdout.write("\r" + posicao_str.ljust(20))
    sys.stdout.flush()
    
    time.sleep(0.1)
