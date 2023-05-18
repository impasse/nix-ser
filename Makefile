.PHONY: update clean fast switch

acp:
	git add .
	git commit -m Fix
	git push

update:
	nix flake update --commit-lock-file

clean:
	sudo nix-collect-garbage -d

fast:
	sudo nixos-rebuild --flake . switch --fast

switch:
	sudo nixos-rebuild --flake . switch --impure


all: update clean switch

