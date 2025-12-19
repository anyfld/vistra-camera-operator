BOARD ?= arduino:avr:uno
PORT ?= $(shell ls /dev/cu.usbmodem* 2>/dev/null | head -1 || ls /dev/ttyUSB* 2>/dev/null | head -1 || echo "/dev/ttyUSB0")
SKETCH_DIR = fd
ARDUINO_CLI = arduino-cli
UV = uv
CD_DIR = cd

.PHONY: all build upload clean monitor install-deps setup-python list-ports run move sample help

all: build

build:
	$(ARDUINO_CLI) compile --fqbn $(BOARD) $(SKETCH_DIR)

upload: build
	$(ARDUINO_CLI) upload --fqbn $(BOARD) --port $(PORT) $(SKETCH_DIR)

clean:
	rm -rf $(SKETCH_DIR)/build
	rm -rf $(CD_DIR)/.venv

monitor:
	$(ARDUINO_CLI) monitor --port $(PORT) --config baudrate=115200

install-deps:
	$(ARDUINO_CLI) core update-index
	$(ARDUINO_CLI) core install arduino:avr
	$(ARDUINO_CLI) lib install Servo

setup-python:
	cd $(CD_DIR) && $(UV) sync

list-ports:
	$(ARDUINO_CLI) board list

run:
	cd $(CD_DIR) && $(UV) run python interactive.py -p $(PORT)

move:
	cd $(CD_DIR) && $(UV) run python interactive.py -s $(SERVO) -a $(ANGLE) -p $(PORT)

sample:
	cd $(CD_DIR) && $(UV) run python sample.py -p $(PORT)

help:
	@echo "make build        - Build firmware"
	@echo "make upload       - Upload firmware"
	@echo "make run          - Interactive mode"
	@echo "make sample       - Run demo"
	@echo "make move SERVO=1 ANGLE=90"
	@echo "make monitor      - Serial monitor"
	@echo "make install-deps - Install dependencies"
	@echo "make setup-python - Setup Python"
	@echo "make list-ports   - List ports"
	@echo "make clean        - Clean"
