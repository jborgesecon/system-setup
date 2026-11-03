# Step-by-Step Solution: Fixing the Laptop Freezes

This guide provides copy-pasteable `bash`/`zsh` commands to fix the four software/driver causes identified in your logs. Every command block is clearly tagged with either **`[SUDO]`** (requires administrator password) or **`[NORMAL USER]`** (runs without `sudo`).

---

## Step 1: Switch the CPU Power Profile to `balanced` (Immediate Effect)

Right now, your CPU is locked at 100% minimum frequency (`4.2 GHz` Turbo, running at 75°C–89°C while idle) because `TuneD` is set to `throughput-performance`. Switching it to `balanced` takes effect immediately and lets your CPU cool down and scale its speed normally.

### 1A. Apply the `balanced` profile `[SUDO]`
```bash
sudo tuned-adm profile balanced
```

### 1B. Verify the CPU frequency and temperature dropped `[NORMAL USER]`
```bash
tuned-adm active
cat /sys/devices/system/cpu/intel_pstate/min_perf_pct
sensors
```
*(You should now see `Current active profile: balanced` and `min_perf_pct` around `11` instead of `100`.)*

---

## Step 2: Apply Kernel Fixes for NVMe SSD, Intel GPU, and CPU C-States

This is the most important step. We will add six safe stability flags to your Linux kernel boot parameters using Fedora's official `grubby` tool:
* `nvme_core.default_ps_max_latency_us=0` — Prevents the Realtek NVMe SSD from entering the broken APST power states that drop the drive offline.
* `pcie_aspm=off` — Prevents the PCIe bus from putting your NVMe SSD into the `L1.2` deep-sleep state that causes system lockups on idle transitions (like at `00:16:37`).
* `i915.enable_psr=0`, `i915.enable_dc=0`, & `i915.enable_sagv=0` — Stops the Intel UHD Graphics driver and System Agent memory controller from stalling or deadlocking across your dual monitors (`eDP-1` `1366x768` Pipe A + `HDMI-A-1` `1920x1080` Pipe B).
* `intel_idle.max_cstate=4` — Prevents the CPU from dropping into the unstable `C8`/`C10` ultra-low voltage states (which cause hard CPU lockups where Caps Lock and audio die instantly) while still allowing normal `C1`–`C6` power saving.

### 2A. Back up your current boot settings first `[SUDO]`
```bash
sudo cp /etc/default/grub /etc/default/grub.backup-$(date +%F)
```

### 2B. Add the stability parameters to all installed kernels `[SUDO]`
```bash
sudo grubby --update-kernel=ALL --args="nvme_core.default_ps_max_latency_us=0 pcie_aspm=off i915.enable_psr=0 i915.enable_dc=0 i915.enable_sagv=0 intel_idle.max_cstate=4"
```

### 2C. Verify the parameters were added `[SUDO]`
```bash
sudo grubby --info=DEFAULT
```
*(Look at the `args=` line in the output—you should see the new parameters listed there.)*

---

## Step 3: Disable the Out-of-Tree VirtualBox Driver (Optional but Recommended)

Every time you boot, `vboxdrv` loads an unsigned out-of-tree module that taints the kernel. If you aren't actively running VirtualBox VMs right now (or since you already have native KVM/`virt-manager` installed), disabling this service removes a known cause of kernel lockups on Fedora `7.2.x` kernels.

### 3A. Stop and disable `vboxdrv` `[SUDO]`
```bash
sudo systemctl disable --now vboxdrv.service
```
*(Note: If you ever want to use VirtualBox later, you can turn it back on anytime with `sudo systemctl start vboxdrv.service`.)*

---

## Step 4: Enable Persistent Crash Logging (`kdump` / SysRq)

Just in case you ever want to test if the keyboard is still alive at the kernel level during a freeze, enabling the Magic SysRq key lets you cleanly sync disks and reboot without corrupting files.

### 4A. Enable the SysRq key permanently `[SUDO]`
```bash
echo "kernel.sysrq = 1" | sudo tee /etc/sysctl.d/90-sysrq.conf
sudo sysctl --system
```

---

## Step 5: Reboot to Activate the Kernel Fixes

The NVMe, PCIe, GPU, and C-state fixes in **Step 2** only take effect after a reboot.

### 5A. Reboot your laptop `[SUDO]`
```bash
sudo reboot
```

---

## Step 6: Verify Everything After Rebooting

Once your laptop turns back on, run this single verification script to confirm all fixes are active.

### 6A. Run the post-reboot check `[NORMAL USER]`
```bash
echo "=== 1. Active Kernel Parameters ==="
cat /proc/cmdline

echo -e "\n=== 2. NVMe APST Latency Setting (Should be 0) ==="
cat /sys/module/nvme_core/parameters/default_ps_max_latency_us

echo -e "\n=== 3. Active TuneD Profile (Should be balanced) ==="
tuned-adm active

echo -e "\n=== 4. Max CPU C-State (Should be 4) ==="
cat /sys/module/intel_idle/parameters/max_cstate

echo -e "\n=== 5. Current Temperatures ==="
sensors
```

---

## All-in-One Automated Script (Optional)

If you prefer to run **Steps 1 through 4** all at once instead of one by one, you can copy and paste this complete script into your terminal:

### Run All Fixes Together `[SUDO]`
```bash
sudo bash -c '
set -e
echo "[1/4] Switching TuneD profile to balanced..."
tuned-adm profile balanced

echo "[2/4] Backing up /etc/default/grub and applying kernel stability parameters..."
cp /etc/default/grub /etc/default/grub.backup-$(date +%F)
grubby --update-kernel=ALL --args="nvme_core.default_ps_max_latency_us=0 pcie_aspm=off i915.enable_psr=0 i915.enable_dc=0 i915.enable_sagv=0 intel_idle.max_cstate=4"

echo "[3/4] Disabling out-of-tree vboxdrv service..."
systemctl disable --now vboxdrv.service || true

echo "[4/4] Enabling SysRq key..."
echo "kernel.sysrq = 1" > /etc/sysctl.d/90-sysrq.conf
sysctl --system >/dev/null

echo "Done! Current default kernel config:"
grubby --info=DEFAULT
echo "Please run: sudo reboot"
'
```

---

## How to Undo / Roll Back (If You Ever Want To)

If you ever want to revert the kernel parameters and return the system to its previous state, run:

### Rollback Script `[SUDO]`
```bash
sudo grubby --update-kernel=ALL --remove-args="nvme_core.default_ps_max_latency_us=0 pcie_aspm=off i915.enable_psr=0 i915.enable_dc=0 i915.enable_sagv=0 intel_idle.max_cstate=4"
sudo systemctl enable --now vboxdrv.service
```
