import System.Random
import System.IO
import Data.String

rand :: IO Int
rand = getStdRandom (randomR (0, 1))

randomInt :: RandomGen g => g -> Int
randomInt gen = fst $ random gen

-- raw data
mkRawData :: IO ()
mkRawData = do
        outputFile <- openFile "../data/rawData.tsv" WriteMode
        let startTime  = 20131130090000
            intervals  = map (+startTime) [2,4..1000]
            randomvals = take 500 $ randomRs (1,10) (mkStdGen 99) :: [Int]
            outputList = zipWith tabJoin intervals randomvals
        hPutStrLn outputFile ("time" ++ "\t" ++ "count")
        mkRawDataLoop outputList outputFile
        hClose outputFile

mkRawDataLoop :: [String] -> Handle -> IO ()
mkRawDataLoop []     _   = return ()
mkRawDataLoop (x:xs) out = do
                       hPutStrLn out x
                       mkRawDataLoop xs out

-- diff data
mkDiffData :: IO ()
mkDiffData = transformFile mkDiff "../data/rawData.tsv" "../data/diffData.tsv"

mkDiff :: [String] -> [String]
mkDiff (firstLine:restLines) = firstLine : (differ restLines)
    where
        differ []     = []
        differ [line] = []
        differ (current:next:rest) = tabJoin diffX diffY : differ rest
            where
                [currX, currY] = tsvLineToInteger current
                [nextX, nextY] = tsvLineToInteger next
                diffX = currX
                diffY = (nextY - currY) `div` (nextX - currX)

mkMaxData :: IO ()
mkMaxData = transformFile mkMax "../data/rawData.tsv" "../data/maxData.tsv"

-- mkAveData :: IO ()
-- mkAveData = interact (unlines . mkAve . lines)

-- UTILITY

transformFile :: ([String] -> [String]) -> FilePath -> FilePath -> IO ()
transformFile f inputPath outputPath = do
    string <- readFile inputPath
    writeFile outputPath $ (unlines . f . lines) string

splitBy :: Eq a => [a] -> [a] -> [[a]]
splitBy _  []     = []
splitBy as xs = y : splitBy as ys
    where
        y  = takeWhile (\x -> not $ elem x as) xs
        ys = drop 1 $ dropWhile (\x -> not $ elem x as) xs

tabSplit = splitBy "\t"
tsvLineToFloat line = map (\str -> read str :: Float) (tabSplit line)
tsvLineToInteger line = map (\str -> read str :: Integer) (tabSplit line)
tabJoin x y = show x ++ "\t" ++ show y


-- wave pattern -> count

-- count data
-- max data

-- 
-- newtype State s a = State {
--                     runState :: s -> (a, s)
--                     }
-- 
-- returnState :: a -> State s a
-- returnState a = State $ \s -> (a, s)
-- 
-- bindState :: State s a -> (a -> State s b) -> State s b
-- bindState m k = State $ \s -> let (a, s') = runState m s
--                                   in runState (k a) s'
-- 
-- get :: State s s
-- get = State $ \s -> (s, s)
-- 
-- put :: s -> State s ()
-- put s = State $ \_ -> ((), s)
-- 
-- type RandomState a = State StdGen a
-- 
-- getRandom :: Random a => RandomState a
-- getRandom =
--         get >>= \gen ->
--         let (val, gen') = random gen in
--             put gen' >>
--             return val
