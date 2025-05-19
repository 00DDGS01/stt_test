# record_voice.py
import sounddevice as sd
from scipy.io.wavfile import write

fs = 16000  # 샘플링 레이트 (Resemblyzer 권장값)
seconds = 5  # 녹음 길이

filename = input("저장할 파일 이름을 입력하세요 (예: user_voice.wav 또는 test_input.wav): ")

print(f"🎙️ {filename} 녹음 시작...")
recording = sd.rec(int(seconds * fs), samplerate=fs, channels=1, dtype='int16')
sd.wait()
write(filename, fs, recording)
print(f"✅ 저장 완료: {filename}")