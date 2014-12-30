import Data.Complex
import qualified Data.Word as W
import qualified Data.Vector.Storable as V
import qualified Codec.Picture as P

main :: IO ()
main = P.writePng "./out.png" $ mandel ((-2):+(-1)) (1:+1) 900 600

type CPoint = Complex Double

mandel :: CPoint -> CPoint -> Int -> Int -> P.Image P.Pixel8
mandel topLeft bottomRight width height = P.Image {
    P.imageWidth = width,
    P.imageHeight = height,
    P.imageData = V.generate (width*height)
        (\n -> let (y,x) = n `divMod` width in
                    convergence (topLeft + dx* fromIntegral x + dy* fromIntegral y))
} where
    dx = (realPart bottomRight - realPart topLeft) / fromIntegral width :+ 0
    dy = 0 :+ (imagPart bottomRight - imagPart topLeft) / fromIntegral height

convergence :: CPoint -> W.Word8
convergence c = convergence' c 5.0 (0:+0) 200

convergence' :: CPoint -> Double -> CPoint -> Int -> W.Word8
convergence' _ _ _ 0 = 0
convergence' c threshold xn n
    | magnitude xn' > threshold = 255 - fromIntegral n
    | otherwise = convergence' c threshold xn' (n-1)
    where
        xn' =  xn*xn + c
