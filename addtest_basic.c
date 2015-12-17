/* addtest_basic.c
	
   Demonstrates using the function imported from the DLL, the inelegant way.
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Declare imported functions. */
extern int __stdcall add2i(int*, int*);
extern double __stdcall add2r(double*, double*);
extern void __stdcall VecRef(int[], int *);
extern void __stdcall VecRefr(double[], double []);
extern void __stdcall VecRefrvarlenght(double[], int*, double [], int*);
extern void __stdcall VecRefRvarlenght_opt(double[], int*, double [], int*, int*);
extern void __stdcall VecRefRvarlenght_opt2(double[], double [], int*);
extern void __stdcall passstringtest(char*, int*);
extern void __stdcall print_hi_array(char input_string[][255], int*);


int main(int argc, char** argv)
{
  // test add2i
  int ii = 66;
  int jj = 654;
  printf("%d\n", add2i(&ii, &jj));

  // test add2r
  double iii = 23.4;
  double jjj = 12.3654;
  printf("%f\n", add2r(&iii, &jjj));

  // test vecref, passing array to fortran, return integer
  int sum;
  int v[9] = {3, 5, 1, 6, 34, 7, 1, 5, 5};
  VecRef( v, &sum );
  printf("%d\n", sum);

  // test vecref, passing array to fortran, return array
  int iprint;
  double *wr_return;
  wr_return = ( double * ) malloc ( ( 3 ) * sizeof ( double ) );
  double vr[9] = {3.2, 5.5, 1.0, 6.9, 34.3, 7.4, 1.1, 5.2, 5.6};
  VecRefr( vr, wr_return );
  for(iprint = 0; iprint < 3; iprint++)
      printf("%f ", wr_return[iprint]);
  printf("\n");

  // test vecref, passing array to fortran, return array; varriable array size on fortran side
  int iprint_var;
  int nwr_var = 3;
  double *wr_return_var;
  wr_return_var = ( double * ) malloc ( ( nwr_var ) * sizeof ( double ) );

  double vr_var[] = {31.2, 35.5, 1.40, 63.9, 34.35, 73.4, 11.11, 55.2, 53.33};
  int nvr_var = sizeof(vr_var) / sizeof(vr_var[0]);

  VecRefrvarlenght( vr_var, &nvr_var, wr_return_var, &nwr_var);
  for(iprint_var = 0; iprint_var < nwr_var; iprint_var++)
      printf("%f ", wr_return_var[iprint_var]);
  printf("\n");

  // test vecref, passing array to fortran, return array; varriable array size on fortran side, with optional input
  int iprint_varo, ios;
  int nwr_varo = 3;
  double *wr_return_varo;
  wr_return_varo = ( double * ) malloc ( ( nwr_varo ) * sizeof ( double ) );

  double vr_varo[] = {311.2, 350.5, 71.40, 463.9, 634.35, 273.4, 111.11, 655.2, 453.33};
  int nvr_varo = sizeof(vr_varo) / sizeof(vr_varo[0]);

  VecRefRvarlenght_opt( vr_varo, &nvr_varo, wr_return_varo, &nwr_varo, &ios);
  for(iprint_varo = 0; iprint_varo < nwr_varo; iprint_varo++)
      printf("%f ", wr_return_varo[iprint_varo]);
  printf("\n");
  printf("%d\n", ios);

  // test vecref, passing array to fortran, return array; varriable array size on fortran side with *, with optional input
  int iprint_varo2, ios2;
  int nwr_varo2 = 3;
  double *wr_return_varo2;
  wr_return_varo2 = ( double * ) malloc ( ( nwr_varo2 ) * sizeof ( double ) );

  double vr_varo2[] = {345.2, 50.5, 7.40, 43.9, 534.35, 23.4, 511.11, 65.2, 43.33};
  int nvr_varo2 = sizeof(vr_varo2) / sizeof(vr_varo2[0]);

  VecRefRvarlenght_opt2( vr_varo2, wr_return_varo2, &ios2);
  for(iprint_varo2 = 0; iprint_varo2 < nwr_varo2; iprint_varo2++)
      printf("%f ", wr_return_varo2[iprint_varo2]);
  printf("\n");
  printf("%d\n", ios2);

  // test passing a string
  char thestring[] = "this is the test string! woot.";
  int nthestring = strlen(thestring);
  passstringtest(thestring, &nthestring);

  int nstring = 3;
  char string[3][255] = {"asdff","ghji","zxcv and testing"};
  print_hi_array(string, &nstring);

  return EXIT_SUCCESS;
}
