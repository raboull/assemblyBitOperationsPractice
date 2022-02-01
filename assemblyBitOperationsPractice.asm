													//Defining macros:
				define(r_x, w19)					//creates macro for register w19 to be r_x
				define(r_y, w20)					//creates macro for register w20 to be r_y
				define(t1, w21)						//creates macro for register w21 to be t1
				define(t2, w22)						//creates macro for register w22 to be t2
				define(t3, w23)						//creates macro for register w23 to be t3
				define(t4, w24)						//creates macro for register w24 to be t4

final_result: 	.string "original: 0x%08X	reversed: 0x%08X\n" 	//print our the original and reversed variables

				.balign 4							//this makes sure that the following instructions are divisible by 4 to align word lengths
				.global main						//pseudo op which sets the start label to main. It will make sure that main label is picked by the linker

main:			stp	x29, x30, [sp, -16]!			//stores the contents of the pair of registers to the stack
				mov	x29, sp							//updates FP to the current Sp

				mov	r_x, 0x07FC07FC					//initialize the x variable

													//Reverse bits in the register r_x
step_1:			and	t1, r_x, 0x55555555				//t1 = r_x & 0x55555555
				lsl	t1, t1, 1						//ti = t1 << 1

				lsr	t2, r_x, 1						//t2 = r_x >> 1
				and	t2, t2, 0x55555555				//t2 = t2 & 0x55555555
				orr	r_y, t1, t2						//r_y = t1 | t2

step_2:			and	t1, r_y, 0x33333333				//t1 = r_y & 0x33333333
				lsl	t1, t1, 2						//t1 = t1 << 2
				lsr	t2, r_y, 2						//t2 = r_y >> 2
				and	t2, t2, 0x33333333				//t2 = t2 & 0x33333333
				orr	r_y, t1, t2						//r_y = t1 | t2

step_3:			and	t1, r_y, 0x0F0F0F0F				//t1 = r_y & 0x0F0F0F0F
				lsl	t1, t1, 4						//t1 = t1 << 4
				lsr	t2, r_y, 4						//t2 = r_y >> 4
				and	t2, t2, 0x0F0F0F0F				//t2 = t2 & 0x0F0F0F0F
				orr	r_y, t1, t2						//r_y = t1 | t2

step_4:			lsl	t1, r_y, 24						//t1 = r_y << 24
				and	t2, r_y, 0xFF00					//t2 = r_y & 0xFF00
				lsl	t2, t2, 8						//t2 = t2 << 8
				lsr	t3, r_y, 8						//t3 = r_y >> 8
				and 	t3, t3, 0xFF00				//t3 = t3 & 0xFF00
				lsr	t4, r_y, 24						//t4 = r_y >> 24
				orr	t3, t3, t4						//t3 = t3 | t4
				orr	t2, t2, t3						//t2 = t2 | t3
				orr	r_y, t1, t2						//r_y = t1 | t2

print_results:	adrp 	x0, final_result			//Arg1: address of the final_result string
				add	x0, x0, :lo12:final_result		//complete the address location
				mov	w1, r_x							//Arg2: x value
				mov	w2, r_y							//Arg3: y value
				bl	printf


done:			ldp	x29, x30, [sp], 16				//restores the state of the FP and LR registers
				ret									//returns control to the calling code (in OS)




