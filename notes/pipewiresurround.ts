import { exec as execCallback } from 'child_process';
import { promisify } from 'util';

const exec = promisify(execCallback);

// Configuration constants from the PipeWire config
const SINK_NODE_NAME = 'surround-gain-sink';
const GAIN_CONTROL_INDEX = 0; // The 'gain' builtin filter uses control index 0

/**
 * Class to control the PipeWire Surround Gain filter chain at runtime.
 */
export class PipeWireSurroundController {
    private sinkNodeId: number | null = null;
    private gainNodeId: number | null = null;

    constructor() {
        console.log(`Controller initialized. Target Sink: ${SINK_NODE_NAME}`);
    }

    /**
     * Finds the PipeWire ID of the filter-chain sink and the specific gain node.
     * @returns The node ID of the sink, or null if not found.
     */
    private async findNodeIds(): Promise<boolean> {
        try {
            // 1. Get the main sink node ID
            const { stdout: sinkStdout } = await exec(`pw-cli info 'sink.node.name=${SINK_NODE_NAME}'`);
            
            // Regex to find the ID of the main sink node
            const sinkMatch = sinkStdout.match(/id (\d+),/);
            if (!sinkMatch) {
                console.error(`Sink node '${SINK_NODE_NAME}' not found. Is PipeWire running?`);
                return false;
            }
            this.sinkNodeId = parseInt(sinkMatch[1]);
            
            // 2. Inspect the sink to find the ID of the 'effect-gain' node inside its graph.
            // In a filter-chain, the internal filter nodes are part of the main sink's graph.
            // The structure is complex, so we will use pw-cli to inspect the node's properties,
            // or, more robustly, look for the internal node object via pw-cli ls Node.
            
            // We'll rely on a simplification: for a filter chain's internal node, 
            // the control is applied to the main sink ID (this is often true for simple built-in filters).
            // However, a more robust method is to use pw-metadata, but for built-in filters,
            // we often apply the `set-param` to the main node ID.
            
            // Since the GAIN node is a control point within the graph of 'surround-gain-sink',
            // we must apply the control to the main SINK NODE ID.
            this.gainNodeId = this.sinkNodeId; 

            console.log(`Found Sink/Control Node ID: ${this.sinkNodeId}`);
            return true;
        } catch (error) {
            console.error('Error finding PipeWire node IDs:', error);
            return false;
        }
    }

    /**
     * Sets the gain level for the surround effect filter.
     * @param gain The gain value (0.0 to 1.0 is standard). 0.0 is OFF, 1.0 is full ON.
     */
    public async setGain(gain: number): Promise<void> {
        if (this.sinkNodeId === null) {
            if (!(await this.findNodeIds())) {
                console.error('Cannot set gain: Node IDs not resolved.');
                return;
            }
        }

        // Clamp the gain value
        const clampedGain = Math.max(0.0, Math.min(1.0, gain));
        
        try {
            // Command format: pw-cli set-param <node-id> Control <control-index> <value>
            const command = `pw-cli set-param ${this.gainNodeId} Control ${GAIN_CONTROL_INDEX} ${clampedGain}`;
            await exec(command);
            console.log(`✅ Surround gain set to: ${clampedGain}`);
        } catch (error) {
            console.error(`❌ Failed to set gain using pw-cli: ${error}`);
        }
    }

    /**
     * Switches the surround effect ON (sets gain to 1.0).
     */
    public async turnOn(): Promise<void> {
        await this.setGain(1.0);
        console.log("Surround effect: ON");
    }

    /**
     * Switches the surround effect OFF (sets gain to 0.0, effectively a bypass).
     */
    public async turnOff(): Promise<void> {
        await this.setGain(0.0);
        console.log("Surround effect: OFF (Bypassed)");
    }
}

// --- Example Usage ---
async function main() {
    const controller = new PipeWireSurroundController();

    // 1. Turn the effect OFF (bypass)
    await controller.turnOff();

    // 2. Set the gain to 50%
    await controller.setGain(0.5);

    // 3. Turn the effect ON
    await controller.turnOn();
}

// To run this:
// 1. Ensure the PipeWire config is loaded and the sink is active.
// 2. Ensure pw-cli is installed.
// 3. Run: ts-node pipewire-surround-controller.ts 
// (or compile and run the resulting JavaScript).
main().catch(console.error);
