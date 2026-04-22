import {
  AbsoluteFill,
  Easing,
  Img,
  interpolate,
  staticFile,
  useCurrentFrame,
  useVideoConfig,
} from 'remotion';

const clamp = {
  extrapolateLeft: 'clamp' as const,
  extrapolateRight: 'clamp' as const,
};

export const CatWave = () => {
  const frame = useCurrentFrame();
  const {fps} = useVideoConfig();

  const intro = interpolate(frame, [0, 0.18 * fps], [0.92, 1], {
    ...clamp,
    easing: Easing.bezier(0.16, 1, 0.3, 1),
  });
  const fadeIn = interpolate(frame, [0, 0.12 * fps], [0, 1], clamp);
  const fadeOut = interpolate(frame, [1.82 * fps, 2 * fps], [1, 0], clamp);
  const waveEnvelope = interpolate(
    frame,
    [0.18 * fps, 0.34 * fps, 1.32 * fps, 1.56 * fps],
    [0, 1, 1, 0],
    clamp,
  );

  const wave = Math.sin(((frame - 0.18 * fps) / fps) * Math.PI * 4);
  const rotation = wave * 7.5 * waveEnvelope;
  const bob = Math.sin((frame / fps) * Math.PI * 2) * 3 * waveEnvelope;

  const accentOne = interpolate(frame, [0.22 * fps, 0.38 * fps], [0, 1], {
    ...clamp,
    easing: Easing.bezier(0.16, 1, 0.3, 1),
  });
  const accentTwo = interpolate(frame, [0.68 * fps, 0.84 * fps], [0, 1], {
    ...clamp,
    easing: Easing.bezier(0.16, 1, 0.3, 1),
  });

  return (
    <AbsoluteFill style={{backgroundColor: 'transparent'}}>
      <AbsoluteFill
        style={{
          alignItems: 'center',
          justifyContent: 'center',
          opacity: fadeIn * fadeOut,
        }}
      >
        <div
          style={{
            position: 'relative',
            width: 420,
            height: 420,
            transform: `translateY(${bob}px) scale(${intro}) rotate(${rotation}deg)`,
            transformOrigin: '64% 72%',
          }}
        >
          <Img
            src={staticFile('cat-avatar-transparent.png')}
            style={{
              width: '100%',
              height: '100%',
              objectFit: 'contain',
            }}
          />
          <WaveAccent progress={accentOne} top={174} right={18} />
          <WaveAccent progress={accentTwo} top={150} right={6} />
        </div>
      </AbsoluteFill>
    </AbsoluteFill>
  );
};

const WaveAccent = ({
  progress,
  top,
  right,
}: {
  progress: number;
  top: number;
  right: number;
}) => {
  const opacity = interpolate(progress, [0, 0.18, 0.72, 1], [0, 1, 1, 0], clamp);
  const scale = interpolate(progress, [0, 1], [0.72, 1.08], clamp);

  return (
    <div
      style={{
        position: 'absolute',
        top,
        right,
        width: 58,
        height: 48,
        opacity,
        transform: `scale(${scale}) rotate(-10deg)`,
        transformOrigin: 'left center',
      }}
    >
      <div style={strokeStyle(0, 18, 36)} />
      <div style={strokeStyle(16, 4, 46)} />
    </div>
  );
};

const strokeStyle = (top: number, left: number, width: number): React.CSSProperties => ({
  position: 'absolute',
  top,
  left,
  width,
  height: 9,
  borderRadius: 999,
  background: '#050505',
  transform: 'rotate(-34deg)',
});
