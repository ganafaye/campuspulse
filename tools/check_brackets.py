from pathlib import Path
p=Path(r'c:\Users\ganaf\Desktop\Dev_mobile\Projet\Projet_campuspulse\campuspulse\lib\presentation\screens\schedule_screen.dart')
s=p.read_text(encoding='utf-8')
counts={'(':0,')':0,'{':0,'}':0,'[':0,']':0}
for ch in s:
    if ch in counts:
        counts[ch]+=1
print('counts=',counts)
print('\nlast 200 chars:\n')
print(s[-400:])
