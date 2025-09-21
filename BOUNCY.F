C
C      SIMPLE BOUNCY BALL PHYSICS SIM TO LEARN F77.
C           AUTHOR: REINITD (GITHUB.COM/REINITD)
C
      PROGRAM BOUNCY
      REAL G,IV,TH,DT,PI,VX,VY,X,Y,T,TFL,THD,BNC,MT,MH
      REAL SX,SY,II,PX,PY,FPY
      INTEGER MAX,TFLS,I,IW,IH
      PARAMETER (G=9.81,MAX=1000000,IW=600,IH=400)
      REAL TRJ(3,MAX)
      INTEGER IMAGE(IW,IH)
      PRINT *,'RUNNING SIMULATION...'
C
      PI=4.0*ATAN(1.0)
C      IV IS INITIAL VELOCITY IN M/S.
      IV=20.0
C      THD IS THETA A/K/A ANGLE IN DEG.
      THD=45.0
C      DT IS TIMESTEP IN SECONDS.
      DT=0.01
C      TH IS THETA A/K/A ANGLE IN RADIANS.
      TH=THD*(PI/180.0)
C      BNC IS THE BOUNCE FACTOR; 0.0-1.0.
      BNC=0.7
C
      VX=IV*COS(TH)
      VY=IV*SIN(TH)
C
      X=0.0
      Y=0.0
      T=0.0
C
      PRINT *,'PI=',PI,', IV=',IV,', THD=',THD,', DT=',DT,', TH=',TH,',
     1VX=',VX,', VY=',VY
C      --- START MAIN SIM LOOP ---
      I = 1
   10 CONTINUE
      IF(I.GT.MAX)GOTO 20

      TRJ(1,I)=T
      TRJ(2,I)=X
      TRJ(3,I)=Y
C
      T=T+DT
      X=X+VX*DT
      Y=Y+VY*DT-0.5*G*DT*DT
      VY=VY-G*DT
      I=I+1
C      .LT.0.9 BECAUSE THERE'S NO POINT RENDERING DATA LESS THAN 1PX. 
      IF(Y.LE.0.0.AND.VY.LT.0.0)THEN
        IF(ABS(VY).LT.0.9)THEN 
          Y=0.0
          VY=0.0
          GOTO 20
        ELSE
          Y=0.0
          VY=-VY*BNC
        END IF
      END IF
C 
      GOTO 10
   20 CONTINUE
C      --- END MAIN SIM LOOP ---
      MT=0.0
      MH=0.0
      II=I
      OPEN(UNIT=77,FILE='DATA.DAT',STATUS='REPLACE',ACTION='WRITE')
      WRITE(77,'(A)')'# TIME (S)   X_POS (M)   Y_POS (M)'
      DO 30 J=1,I-1
        IF(TRJ(1,J).GT.MT)MT=TRJ(1,J)
        IF(TRJ(3,J).GT.MH)MH=TRJ(3,J)
        WRITE(77,*)TRJ(1,J),TRJ(2,J),TRJ(3,J)
        PRINT *,'T=',TRJ(1,J),', X=',TRJ(2,J),', Y=',TRJ(3,J)
   30 CONTINUE
      CLOSE(77)
      PRINT *,'MT=',MT,', MH=',MH
      PRINT *,'FINDING MAX HEIGHT OF EACH BOUNCE...'
      OPEN(UNIT=88,FILE='PEAKS.DAT',STATUS='REPLACE',ACTION='WRITE')
      DO J=2, II-2
        IF(TRJ(3,J).GT.TRJ(3,J-1).AND.
     1     TRJ(3,J).GT.TRJ(3,J+1))THEN
          WRITE(88,801)TRJ(1,J),TRJ(3,J),TRJ(3,J)
  801     FORMAT(F8.2,2(1X,F8.2))
        END IF
      END DO 
      CLOSE(88)
C
      PRINT *,'MAKING GRAPH...'
      SX=(IW/MT)-2
      SY=(IH/MH)-1
      DO J=1,IH
        DO K=1,IW
          IMAGE(K,J)=255
        END DO
      END DO
      DO 40 J=1,II-1
        PX=TRJ(1,J)*SX
        PY=TRJ(3,J)*SY
        FPY=IH-PY
        IMAGE(NINT(PX),NINT(FPY))=0
   40 CONTINUE
      OPEN(UNIT=99,FILE='TRAJ.PGM',STATUS='REPLACE',ACTION='WRITE')
      WRITE(99,'(A2)')'P2'
      WRITE(99,901)IW,' ',IH
  901 FORMAT(I0,A1,I0)
      WRITE(99,'(I3)')255
      DO J=1,IH
        DO K=1,IW
          WRITE(99,'(I0,1X)',ADVANCE='NO')IMAGE(K,J)
        END DO
        WRITE(99,'(1X)')
      END DO
      CLOSE(UNIT=99)
C 
      PRINT *,'DONE.'
      END
