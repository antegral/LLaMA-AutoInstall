export REPOSITORY_ORIGINAL="https://huggingface.co/decapoda-research/llama-13b-hf"
export REPOSITORY_QUANTIZED="https://huggingface.co/decapoda-research/llama-13b-hf-int4"
export REPOSITORY_ORIGINAL_NAME="llama-13b-hf"
export REPOSITORY_QUANTIZED_NAME="llama-13b-hf-int4"

if [ -f "/var/AutoInstall-Status.txt" ]; then
  echo "[1/3] Downloading LLaMA Original models...";
  cd /text-generation-webui/models;
  git lfs install &&
  git clone ${REPOSITORY_ORIGINAL} &&

  echo "[2/3] Downloading Tokenizer...";
  cd /text-generation-webui/models/&{REPOSITORY_ORIGINAL_NAME};
  wget https://cdn.antegral.net/public/LLaMA/tokenizer.model &&
  wget https://cdn.antegral.net/public/LLaMA/tokenizer_checklist.chk &&

  echo "[3/3] Downloading LLaMA Quantized models.."
  git clone ${REPOSITORY_QUANTIZED} &&
  mv /text-generation-webui/models/&{REPOSITORY_QUANTIZED_NAME}/&{REPOSITORY_QUANTIZED_NAME}.pt /text-generation-webui/models;
  rm -rf /text-generation-webui/models/&{REPOSITORY_QUANTIZED_NAME};
  cd /var;
  echo "true" >> AutoInstall-Status.txt;
else
    echo "Already installed. install process skipped.";
fi

echo "Starting WebUI...";

cd /text-generation-webui;
python server.py --listen --load-in-4bit --chat --disk &&
echo "WebUI Stopped.";
