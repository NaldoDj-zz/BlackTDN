CREATE FUNCTION [dbo].[FormatDinheiro](@Valor DECIMAL(20, 2))
RETURNS VARCHAR(30)
AS 
BEGIN

DECLARE @ValorStr VARCHAR(30),
        @Inteiro VARCHAR(30),
        @Decimal VARCHAR(3),
        @I INT,
        @Count INT,
        @IntLen INT

SET @ValorStr = CONVERT( VARCHAR(30), @Valor )
SET @ValorStr = RTRIM( LTRIM( REPLACE( @ValorStr, '.', '' ) ) )
SET @ValorStr = REPLACE( @ValorStr, ',', '' )
SET @Inteiro = ''

IF (Len(@ValorStr) = 1)
BEGIN
   SET @Inteiro = '0'
   SET @Decimal = '0'+@ValorStr
END
ELSE
BEGIN
  IF (Len(@ValorStr) = 2)
  BEGIN
    SET @Inteiro = '0'
    SET @Decimal = @ValorStr
  END
  ELSE
  BEGIN
    SET @Decimal = Substring(@ValorStr, (Len(@ValorStr)-1), Len(@ValorStr))
    SET @I = 3
    SET @Count = 0
    WHILE (@I <= Len(@ValorStr))
    BEGIN
      IF (@Count = 3)
      BEGIN
        SET @Inteiro = '.'+@Inteiro
        SET @Count = 0
      END
      SET @IntLen = (Len(@ValorStr)+1)-@I
      IF (@IntLen >= 0)
      BEGIN
        SET @Inteiro = Substring(@ValorStr, @IntLen, 1)+@Inteiro
      END
      SET @I = @I + 1
      SET @Count = @Count + 1
    END
  END
END

IF (@Inteiro = '') SET @Inteiro = '0'
IF (@Decimal = '') SET @Decimal = '00'

RETURN 'R$ '+@Inteiro+','+@Decimal

END
