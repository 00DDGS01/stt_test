# resemblyzer_test/verify_speaker.py

from resemblyzer import VoiceEncoder, preprocess_wav
from pathlib import Path
import numpy as np
import sys

# 음성 파일 경로 인자 받기
if len(sys.argv) != 3:
    print("Usage: python verify_speaker.py user.wav input.wav")
    sys.exit(1)

user_path = Path(sys.argv[1])
input_path = Path(sys.argv[2])

print("✅ 사용자 음성 파일:", user_path)
print("✅ 비교 음성 파일:", input_path)

# 임베딩 생성
encoder = VoiceEncoder()
user_embed = encoder.embed_utterance(preprocess_wav(user_path))
input_embed = encoder.embed_utterance(preprocess_wav(input_path))

# 유사도 계산
similarity = np.dot(user_embed, input_embed)
print(f"{similarity:.4f}")

